pragma solidity ^0.4.24;

contract Quiz {

    struct Answer{
        string text; //答案的內容 
        uint hearts; //答案的讚數
    }
    
    struct Option{
        string text; //選項的內容
        uint voteCount; //選項的投票數
    }
    
    struct Question{
        string questionName; //題目的主旨
        string text; //題目的內容
        string userName; //建立題目的使用者名稱
        string time; //建立題目的時間
        uint[] answerList; //list of answer keys so we can look them up
        mapping(uint => Answer) answerStructs; //答案的struct，用answerNumber取得 
        uint[] optionList; 
        mapping(uint => Option) optionStructs; //選項的struct，用optionNumber取得
    }
    
    mapping(uint => Question) questionStructs; // 題目的struct，用qusetionNumber(題目編號)取得 
    uint[] questionList; // list of question keys so we can enumerate them

    //事件記得寫
    
    //建立一個新題目
    function newQuestion(string _questionName ,string _text, string _userName, string _time) public returns (bool success){
        // not checking for duplicates
        uint _questionNumber = questionList.length + 1;
        questionStructs[_questionNumber].questionName = _questionName;
        questionStructs[_questionNumber].text = _text;
        questionStructs[_questionNumber].userName = _userName;
        questionStructs[_questionNumber].time = _time;
        questionList.push(_questionNumber);
        return true;
    }
    
    //回傳題目資訊
    function getQuestion(uint _questionNumber) public constant returns(string questionName, string text, string userNamename, string time, uint optionCount, uint answerCount){
        return(
            questionStructs[_questionNumber].questionName,
            questionStructs[_questionNumber].text,
            questionStructs[_questionNumber].userName, 
            questionStructs[_questionNumber].time,
            questionStructs[_questionNumber].answerList.length,
            questionStructs[_questionNumber].optionList.length);
    }

    //新增選項
    function addOption(uint _questionNumber,uint _optionNumber,string _optionText) public returns(bool success){
        questionStructs[_questionNumber].optionList.push(_optionNumber);
        questionStructs[_questionNumber].optionStructs[_optionNumber].text = _optionText;
        return true;
    }

    //統計選項的票數
    function countOption(uint _questionNumber,uint _optionNumber) public constant returns(uint count){
        return(questionStructs[_questionNumber].optionStructs[_optionNumber].voteCount);
    }

    //對選項投票
    function voteOption(uint _questionNumber,uint _optionNumber) public constant returns(bool success){
        questionStructs[_questionNumber].optionStructs[_optionNumber].voteCount +1;
        return true;
    }

    //回傳選項(還沒解決回傳string[]的問題)
    //function getOption
    
    //新增答案
    function addAnswer(uint _questionNumber, uint _answerNumber, string _answerText) public returns(bool success){
        questionStructs[_questionNumber].answerList.push(_answerNumber);
        questionStructs[_questionNumber].answerStructs[_answerNumber].text = _answerText;
        // answer vote will init to 0 without our help
        return true;
    }
    
    //取得答案
    function getQuestionAnswer(uint _questionNumber, uint _answerNumber) public constant returns(string answerText, uint answerHeart){
        return(
            questionStructs[_questionNumber].answerStructs[_answerNumber].text,
            questionStructs[_questionNumber].answerStructs[_answerNumber].hearts);
    }
    
    //計算有多少題目
    function getQuestionCount() public constant returns(uint questionCount){
        return questionList.length;
    }
    
    //用題目編號得知題目名稱
    function getQuestionAtIndex(uint _questionNumber) public constant returns(string question){
        return questionStructs[_questionNumber].questionName;
    }
    
    //得到題目有幾個答案
    function getQuestionAnswerCount(uint _questionNumber) public constant returns(uint answerCount){
        return(questionStructs[_questionNumber].answerList.length);
    }
    
    //對於題目的答案按讚
    function addHeart(uint _questionNumber, uint _answerNumber) public constant returns(uint hearts){
        questionStructs[_questionNumber].answerStructs[_answerNumber].hearts + 1;
        return(questionStructs[_questionNumber].answerStructs[_answerNumber].hearts);
    }
    
    /*function getQuestionAnswerAtIndex(string questionNumber, uint answerRow) public constant returns(string answerNumber)
    {
        return(questionStructs[questionNumber].answerList[answerRow]);
    }*/

}