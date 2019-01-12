# class DummyClass
# end
#
# RSpec.describe DummyClass do
#   before(:each) do
#     @dummy_class = DummyClass.new
#     @dummy_class.extend(Respondent)
#   end
#
#   it "get hello string" do
#     expect { @dummy_class.greeting }.to output(I18n.t(:greeting)).to_stdout
#   end
#
#   it "while process string" do
#     expect { @dummy_class.in_process }.to output(I18n.t(:in_process)).to_stdout
#   end
#
#   it "while wrong input action" do
#     expect { @dummy_class.wrong_input_action }.to output(I18n.t(:wrong_input_action)).to_stdout
#   end
#
#   it "while choose difficulty" do
#     expect { @dummy_class.select_difficulty }.to output(I18n.t(:select_difficulty)).to_stdout
#   end
#
#   it "while choose action" do
#     expect { @dummy_class.for_choose_action }.to output(I18n.t(:choose_action)).to_stdout
#   end
#
#   it "while show smt" do
#     @argument = "argument\n"
#     expect { @dummy_class.show @argument}.to output(@argument).to_stdout
#   end
#
#   it "while wrong input guess" do
#     expect { @dummy_class.incorrect_guess }.to output(I18n.t(:when_incorrect_guess)).to_stdout
#   end
#
#   it "if lose" do
#     expect { @dummy_class.lose }.to output(I18n.t(:when_lose)).to_stdout
#   end
#
#   it "if win" do
#     expect { @dummy_class.win }.to output(I18n.t(:when_win)).to_stdout
#   end
#
#   it "with ask name" do
#     expect { @dummy_class.ask_name }.to output(I18n.t(:ask_name)).to_stdout
#   end
#
#   it "with exit" do
#     expect { @dummy_class.leave_output }.to output(I18n.t(:leave)).to_stdout
#   end
#
# end
