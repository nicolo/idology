require 'spec_helper'
require 'byebug'

include IDology

describe Response do
  
  describe "error" do
    it "should set the error message" do
      response = parse_response('error_response')
      response.error.should == 'Your IP address is not registered. Please call IDology Customer Service (770-984-4697).'
    end
  end
  
  describe "identifying a match" do 
    before do
      @response = parse_response('match_found_response')
    end
    
    describe "when using summary results" do
      it "should not be identified" do
        IDology[:summary_results] = true
        @response.should_not be_identified
      end
    end
    
    describe "when not using summary results" do
      it "should be identified" do
        IDology[:summary_results] = false
        @response.should be_identified
      end
    end
  end
  
  describe "with questions" do
    before do
      @response = parse_response('questions_response')
    end
    
    it "should set the questions" do
      @response.questions.should_not be_empty
      @response.questions.size.should == 3
    end
    
    it "should include answers" do
      @response.questions.each do |question|
        question.answers.size.should == 6
        question.answers.last.should == 'None of the above'
      end
    end
  end

  describe 'match identified with failure' do
    before do
      @response = parse_response 'match_found_subject_deceased'
      IDology[:summary_results] = true
    end

    it 'is not identified' do
      @response.should_not be_identified
    end

    it 'is matched' do
      @response.should be_matched
    end
  end
  
  describe "with qualifiers" do
    before do
      @response = parse_response('match_found_ssn_does_not_match')
    end
    
    it "should set the qualifiers" do
      @response.qualifiers.should_not be_empty
      @response.qualifiers.size.should == 2
    end
  end
  
  describe "with IQ result" do
    before do
      @response = parse_response('challenge_questions_response')
    end
    
    it "should set the IQ result" do
      @response.iq_result.should_not be_nil
      @response.iq_result.key.should == 'result.questions.2.incorrect'
      @response.iq_result.message.should == 'Two Incorrect Answers'
    end
  end
  
  describe "with velocity warnings" do
    before do
      @response = parse_response('velocity_warning')
    end
    
    it "should set the IQ result" do
      @response.velocity_results.should_not be_nil
      @response.velocity_results.size.should == 2
    end
  end
  
  describe "with an error" do 
    before do
      @response = parse_response('error_response')
    end
    
    it "should have an error" do
      @response.should be_error
    end
    
    it "should not be identified" do
      @response.should_not be_identified
    end
    
    it "should not be verified" do
      @response.should_not be_verified
    end
    
    it "should not be eligible for verification" do
      @response.should_not be_eligible_for_verification
    end
  end

  describe 'id_note_score' do
    before do
      @response = parse_response('match_found_global_watch_list')
    end

    it "should retrieve the score" do
      @response.id_note_score.should eq 500
    end
  end
  
  describe "fixtures" do
    Dir.glob(File.dirname(__FILE__)+'/fixtures/*.xml').each do |fixture|
      file = fixture.match(/([^\/]*)\.xml$/)[1]
      it "#{file} should be valid" do
        lambda{ XML::Parser.string(load_response(file)).parse }.should_not raise_error
      end
    end
    
  end
end
