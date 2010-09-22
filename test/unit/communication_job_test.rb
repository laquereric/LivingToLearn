class CommunicationJobTest < ActiveSupport::TestCase

  def setup
  end

  def test_should_be_able_to_create
    cjs= Communication::Job.new
    cjs.classname = 'Communication::LocalPayers::RapidResults'
    cjs.last_printed = 200
    cjs.save
    cjr= Communication::Job.first
    assert_equal cjr.classname, cjs.classname
    assert_equal cjr.last_printed, cjs.last_printed
  end

end
