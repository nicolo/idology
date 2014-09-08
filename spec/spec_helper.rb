$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'idology'
require 'idology_test_helper'
require 'set' # for Enumerable#to_set

module RequestSpecHelper
  include IDology

  def test_subject
    subject = Subject.new(
      {
        # basic info
        :firstName => 'Test',
        :lastName => 'Person',
        :address => '123 Main St',
        :city => 'New York',
        :state => 'NY',
        :zip => 10001,
        :ssnLast4 => 1234,
        :dobMonth => 1,
        :dobYear => 1980,
        :uid => 1,
      }
    )

    # more for aditional tests
    subject.idNumber = 12345
    subject.verification_questions = test_verification_questions
    subject.challenge_questions = test_challenge_verification_questions


    return subject
  end

  def test_verification_questions
    questions = []

    # question 1 with answers
    q = Question.new
    q.prompt = "TEST - With which name are you associated?"
    q.type = "question.type1"
    q.answers = []
    q.answers << "JANNE"
    q.answers << "JESH"
    q.answers << "JAVAD"
    q.answers << "JOSEPH"
    q.answers << "JULES"
    q.answers << "None of the above"
    q.chosen_answer = "JANNE"
    questions << q

    # question 2 with answers
    q = Question.new
    q.prompt = "TEST - Which number goes with your address on CARVER BLVD?"
    q.type = "question.type2"
    q.answers = []
    q.answers << "142"
    q.answers << "117"
    q.answers << "850"
    q.answers << "9101"
    q.answers << "504"
    q.answers << "None of the above"
    q.chosen_answer = "142"
    questions << q

    # question 3 with answers
    q = Question.new
    q.prompt = "TEST - Which cross street is near your address on HALBURTON RD?"
    q.type = "question.type3"
    q.answers = []
    q.answers << "MEADOW ST"
    q.answers << "BELVOIR BLVD"
    q.answers << "LINCOLN ST"
    q.answers << "LOCUST AVE"
    q.answers << "19TH ST"
    q.answers << "None of the above"
    q.chosen_answer = "MEADOW ST"
    questions << q

    return questions
  end

  def test_challenge_verification_questions
    questions = []

    # question 1 with answers
    q = Question.new
    q.prompt = "TEST CHALLENGE - With which name are you associated?"
    q.type = "question.type1"
    q.answers = []
    q.answers << "JANNE"
    q.answers << "JESH"
    q.answers << "JAVAD"
    q.answers << "JOSEPH"
    q.answers << "JULES"
    q.answers << "None of the above"
    q.chosen_answer = "JANNE"
    questions << q

    # question 2 with answers
    q = Question.new
    q.prompt = "TEST CHALLENGE - Which number goes with your address on CARVER BLVD?"
    q.type = "question.type2"
    q.answers = []
    q.answers << "142"
    q.answers << "117"
    q.answers << "850"
    q.answers << "9101"
    q.answers << "504"
    q.answers << "None of the above"
    q.chosen_answer = "142"
    questions << q

    return questions
  end
end

include IDology::TestHelper
FakeWeb.allow_net_connect = false

def load_response(name)
  load_idology_response(name)
end

def parse_response(name)
  parse_idology_response(name)
end
