# frozen_string_literal: true

require 'capybara/plugins/select2'

Capybara::SpecHelper.spec "Plugin", requires: [:js] do
  before do
    @session.visit('https://select2.org/appearance')
  end

  it "should raise if wrong plugin specified" do
    expect do
      @session.select 'Florida', from: 'Click this to focus the single select element', using: :select3
    end.to raise_error(ArgumentError, /Plugin not loaded/)
  end

  it "should raise if non-implemented action is called" do
    expect do
      @session.click_on('blah', using: :select2)
    end.to raise_error(NoMethodError, /Action not implemented/)
  end

  it "should select an option" do
    @session.select 'Florida', from: 'Click this to focus the single select element', using: :select2

    expect(@session).to have_field(type: 'select', with: 'FL', visible: false)
  end

  it "should work with multiple select" do
    @session.select 'Pennsylvania', from: 'Click this to focus the multiple select element', using: :select2
    @session.select 'California', from: 'Click this to focus the multiple select element', using: :select2

    expect(@session).to have_select(multiple: true, selected: %w[Pennsylvania California], visible: false)
  end

  it "should work with id" do
    @session.select 'Florida', from: 'id_label_single', using: :select2
    expect(@session).to have_field(type: 'select', with: 'FL', visible: false)
  end

  it "works without :from" do
    @session.within(:css, 'div.s2-example:nth-of-type(2) p:first-child') do
      @session.select 'Florida', using: :select2
      expect(@session).to have_field(type: 'select', with: 'FL', visible: false)
    end
  end
end
