require "rails_helper"
require 'csv'

RSpec.describe RushingController, type: :controller do
  describe 'GET show_stats' do
    let(:qb) { FactoryBot.create(:qb) }
    let(:rb) { FactoryBot.create(:rb) }
    let(:min) { FactoryBot.create(:min) }
    let(:jax) { FactoryBot.create(:jax) }
    let(:shaun_hill) { FactoryBot.create(:shaun_hill, team: min, position: qb) }
    let(:adrian_peterson) { FactoryBot.create(:all_day, team: min, position: rb) }
    let(:joe_banyard) { FactoryBot.create(:joe_banyard, team: jax, position: rb) }

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

      end

      it 'returns with a sort order, descending' do

      end

      it 'does not order when not a sortable column' do

      end

      it 'returns with a query and sort' do

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
      it_behaves_like 'basic fetching of results', 'json'

      it 'returns results for the current page' do
      end

      it 'disables next when at the last page' do

      end

      it 'disables back when at the first page' do

      end
    end

    def format_for_csv_output(player, csv_headers_map)
      CSV.generate_line(
        csv_headers_map.map do |header, col|
          case header
          when 'Player'
            player.name
          when 'Team'
            player.team.name
          when 'Pos'
            player.position.name
          else
            player.rushing.send(col)
          end
        end
      )
    end

    context 'CSV format' do
      let(:csv_headers_map) { RushingCsvFormatter.get_csv_header }
      let(:all_results) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(shaun_hill, csv_headers_map)}#{format_for_csv_output(adrian_peterson, csv_headers_map)}#{format_for_csv_output(joe_banyard, csv_headers_map)}"
      }
      let(:query_results) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(joe_banyard, csv_headers_map)}"
      }

      it_behaves_like 'basic fetching of results', 'csv'
    end
  end
end
