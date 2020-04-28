require "rails_helper"

RSpec.describe Rushing, type: :model do
  it "contains the correct sortable columns" do
    expect(Rushing.sortable_columns).to match_array([:yards, :longest, :tds])
  end
end
