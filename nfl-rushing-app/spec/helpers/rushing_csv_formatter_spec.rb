require "rails_helper"
require 'csv'
require 'support/csv_formatting_helper'

RSpec.configure do |c|
  c.include CsvFormattingHelper
end

RSpec.describe RushingCsvFormatter, type: :helper do
  describe 'build_csv_enumerator' do
    let(:qb) { FactoryBot.create(:qb) }
    let(:rb) { FactoryBot.create(:rb) }
    let(:min) { FactoryBot.create(:min) }
    let(:jax) { FactoryBot.create(:jax) }
    let(:shaun_hill) { FactoryBot.create(:shaun_hill, team: min, position: qb) }
    let(:adrian_peterson) { FactoryBot.create(:all_day, team: min, position: rb) }
    let(:joe_banyard) { FactoryBot.create(:joe_banyard, team: jax, position: rb) }
    let(:sf) { FactoryBot.create(:sf) }
    let(:shaun_draughn) { FactoryBot.create(:shaun_draughn, team: sf, position: rb) }
    let(:csv_headers_map) { RushingCsvFormatter.get_csv_header }
    let(:player_rushing_relation) { Rushing.joins(:player).joins(player: [:team, :position]) }

    before :each do
      FactoryBot.create(:bad_rushing, player: shaun_hill)
      FactoryBot.create(:good_rushing, player: adrian_peterson)
      FactoryBot.create(:avg_rushing, player: joe_banyard)
      FactoryBot.create(:avg_rushing, player: shaun_draughn, yards: 367)
    end

    RSpec.shared_examples 'results in CSV format' do
      it 'returns results' do
        output = ''
        RushingCsvFormatter.build_csv_enumerator(player_rushing_relation, RushingController::RUSHING_SELECT, order_clause).each do |x|
          output << x
        end
        expect(output).to eq(expected_output)
      end
    end

    context 'all basic results' do
      let(:expected_output) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(shaun_hill, csv_headers_map)}#{format_for_csv_output(adrian_peterson, csv_headers_map)}#{format_for_csv_output(joe_banyard, csv_headers_map)}#{format_for_csv_output(shaun_draughn, csv_headers_map)}"
      }
      let(:order_clause) { nil }
      it_behaves_like 'results in CSV format'
    end

    context 'sorted results' do
      let(:expected_output) {
        "#{CSV.generate_line(csv_headers_map.keys)}#{format_for_csv_output(shaun_hill, csv_headers_map)}#{format_for_csv_output(joe_banyard, csv_headers_map)}#{format_for_csv_output(shaun_draughn, csv_headers_map)}#{format_for_csv_output(adrian_peterson, csv_headers_map)}"
      }
      let(:order_clause) { 'yards ASC' }
      it_behaves_like 'results in CSV format'
    end
  end
end
