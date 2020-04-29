require "rails_helper"
require 'csv'
require 'support/csv_formatting_helper'

RSpec.configure do |c|
  c.include CsvFormattingHelper
end

RSpec.describe RushingController, type: :controller do
  describe 'GET show_stats' do
    let(:qb) { FactoryBot.create(:qb) }
    let(:rb) { FactoryBot.create(:rb) }
    let(:min) { FactoryBot.create(:min) }
    let(:jax) { FactoryBot.create(:jax) }
    let(:shaun_hill) { FactoryBot.create(:shaun_hill, team: min, position: qb) }
    let(:adrian_peterson) { FactoryBot.create(:all_day, team: min, position: rb) }
    let(:joe_banyard) { FactoryBot.create(:joe_banyard, team: jax, position: rb) }
    let(:sf) { FactoryBot.create(:sf) }
    let(:shaun_draughn) { FactoryBot.create(:shaun_draughn, team: sf, position: rb) }

    before :each do
      FactoryBot.create(:bad_rushing, player: shaun_hill)
      FactoryBot.create(:good_rushing, player: adrian_peterson)
      FactoryBot.create(:avg_rushing, player: joe_banyard)
    end

    RSpec.shared_examples 'basic fetching of results' do |format|
      it 'returns all results' do
        get :show_stats, params: { page_num: 1, page_size: 10 }, format: format
        expect(response.body).to eq(all_results)
      end

      it 'returns with a query' do
        get :show_stats, params: { page_num: 1, page_size: 10, query: 'ban' }, format: format
        expect(response.body).to eq(query_results)
      end

      it 'returns with a sort order, ascending' do
        get :show_stats, params: { page_num: 1, page_size: 10, sort_by: 'yards', order_dir: 'asc' }, format: format
        expect(response.body).to eq(sort_asc_results)
      end

      it 'returns with a sort order, descending' do
        get :show_stats, params: { page_num: 1, page_size: 10, sort_by: 'yards', order_dir: 'desc' }, format: format
        expect(response.body).to eq(sort_desc_results)
      end

      it 'does not order when not a sortable column' do
        get :show_stats, params: { page_num: 1, page_size: 10, sort_by: 'attempts_per_game', order_dir: 'desc' }, format: format
        expect(response.body).to eq(all_results)
      end

      it 'returns with a query and sort' do
        FactoryBot.create(:avg_rushing, player: shaun_draughn)
        get :show_stats, params: { page_num: 1, page_size: 10, sort_by: 'yards', order_dir: 'asc', query: 'shaun' }, format: format
        expect(response.body).to eq(query_sort_results)
      end
    end

    def format_for_output(player)
      player.rushing.attributes.merge({
        name: player.name,
        team_name: player.team.name,
        pos: player.position.name,
      })
    end

    context 'JSON format' do
      let(:all_results) {
        {
          stats: [
            format_for_output(shaun_hill),
            format_for_output(adrian_peterson),
            format_for_output(joe_banyard),
          ],
          enable_back: false,
          enable_next: false,
        }.to_json
      }
      let(:query_results) {
        {
          stats: [
            format_for_output(joe_banyard),
          ],
          enable_back: false,
          enable_next: false,
        }.to_json
      }
      let(:sort_asc_results) {
        {
          stats: [
            format_for_output(shaun_hill),
            format_for_output(joe_banyard),
            format_for_output(adrian_peterson),
          ],
          enable_back: false,
          enable_next: false,
        }.to_json
      }
      let(:sort_desc_results) {
        {
          stats: [
            format_for_output(adrian_peterson),
            format_for_output(joe_banyard),
            format_for_output(shaun_hill),
          ],
          enable_back: false,
          enable_next: false,
        }.to_json
      }
      let(:query_sort_results) {
        {
          stats: [
            format_for_output(shaun_hill),
            format_for_output(shaun_draughn),
          ],
          enable_back: false,
          enable_next: false,
        }.to_json
      }

      it_behaves_like 'basic fetching of results', 'json'

      it 'returns results for the current page' do
        expected_results = {
          stats: [
            format_for_output(joe_banyard),
          ],
          enable_back: true,
          enable_next: true,
        }.to_json
        get :show_stats, params: { page_num: 2, page_size: 1, sort_by: 'yards', order_dir: 'asc' }, format: 'json'
        expect(response.body).to eq(expected_results)
      end

      it 'disables next when at the last page' do
        expected_results = {
          stats: [
            format_for_output(adrian_peterson),
          ],
          enable_back: true,
          enable_next: false,
        }.to_json
        get :show_stats, params: { page_num: 3, page_size: 1, sort_by: 'yards', order_dir: 'asc' }, format: 'json'
        expect(response.body).to eq(expected_results)
      end

      it 'disables back when at the first page' do
        expected_results = {
          stats: [
            format_for_output(shaun_hill),
          ],
          enable_back: false,
          enable_next: true,
        }.to_json
        get :show_stats, params: { page_num: 1, page_size: 1, sort_by: 'yards', order_dir: 'asc' }, format: 'json'
        expect(response.body).to eq(expected_results)
      end
    end

    context 'CSV format' do
      let(:csv_headers_map) { RushingCsvFormatter.get_csv_header }
      let(:all_results) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(shaun_hill, csv_headers_map)}#{format_for_csv_output(adrian_peterson, csv_headers_map)}#{format_for_csv_output(joe_banyard, csv_headers_map)}"
      }
      let(:query_results) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(joe_banyard, csv_headers_map)}"
      }
      let(:sort_asc_results) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(shaun_hill, csv_headers_map)}#{format_for_csv_output(joe_banyard, csv_headers_map)}#{format_for_csv_output(adrian_peterson, csv_headers_map)}"
      }
      let(:sort_desc_results) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(adrian_peterson, csv_headers_map)}#{format_for_csv_output(joe_banyard, csv_headers_map)}#{format_for_csv_output(shaun_hill, csv_headers_map)}"
      }
      let(:query_sort_results) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(shaun_hill, csv_headers_map)}#{format_for_csv_output(shaun_draughn, csv_headers_map)}"
      }

      it_behaves_like 'basic fetching of results', 'csv'
    end
  end
end
