require 'rails_helper'

RSpec.describe Commenting, type: :model do
    # #6
    it { is_expected.to belong_to :commentable }
end