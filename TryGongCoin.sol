pragma solidity ^0.4.24;
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";



contract TryGongToken is StandardToken{
      string public name = "TryGongCoin";
      string public symbol = "TGC";
      uint8 public decimals = 3;
      uint256 public INITIAL_SUPPLY = 1000000000000000000000;
    
      constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
  }
}


contract timer {
     /*
         *  Date and Time utilities for ethereum contracts
         *
         */
        struct _DateTime {
                uint16 year;
                uint8 month;
                uint8 day;
                uint8 hour;
                uint8 minute;
                uint8 second;
                uint8 weekday;
        }

        uint constant DAY_IN_SECONDS = 86400;
        uint constant YEAR_IN_SECONDS = 31536000;
        uint constant LEAP_YEAR_IN_SECONDS = 31622400;

        uint constant HOUR_IN_SECONDS = 3600;
        uint constant MINUTE_IN_SECONDS = 60;

        uint16 constant ORIGIN_YEAR = 1970;

        function getNow() public constant returns (uint time){
            uint chainStartTime = now;
            return chainStartTime;
        }

        function isLeapYear(uint16 year) public pure returns (bool) {
                if (year % 4 != 0) {
                        return false;
                }
                if (year % 100 != 0) {
                        return true;
                }
                if (year % 400 != 0) {
                        return false;
                }
                return true;
        }

        function leapYearsBefore(uint year) public pure returns (uint) {
                year -= 1;
                return year / 4 - year / 100 + year / 400;
        }

        function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                        return 31;
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11) {
                        return 30;
                }
                else if (isLeapYear(year)) {
                        return 29;
                }
                else {
                        return 28;
                }
        }

        function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
                uint secondsAccountedFor = 0;
                uint buf;
                uint8 i;

                // Year
                dt.year = getYear(timestamp);
                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

                // Month
                uint secondsInMonth;
                for (i = 1; i <= 12; i++) {
                        secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
                        if (secondsInMonth + secondsAccountedFor > timestamp) {
                                dt.month = i;
                                break;
                        }
                        secondsAccountedFor += secondsInMonth;
                }

                // Day
                for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.day = i;
                                break;
                        }
                        secondsAccountedFor += DAY_IN_SECONDS;
                }

                // Hour
                dt.hour = getHour(timestamp);

                // Minute
                dt.minute = getMinute(timestamp);

                // Second
                dt.second = getSecond(timestamp);

                // Day of week.
                dt.weekday = getWeekday(timestamp);
        }

        function getYear(uint timestamp) public pure returns (uint16) {
                uint secondsAccountedFor = 0;
                uint16 year;
                uint numLeapYears;

                // Year
                year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

                while (secondsAccountedFor > timestamp) {
                        if (isLeapYear(uint16(year - 1))) {
                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                secondsAccountedFor -= YEAR_IN_SECONDS;
                        }
                        year -= 1;
                }
                return year;
        }

        function getMonth(uint timestamp) public pure returns (uint8) {
                return parseTimestamp(timestamp).month;
        }

        function getDay(uint timestamp) public pure returns (uint8) {
                return parseTimestamp(timestamp).day;
        }

        function getHour(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / 60 / 60) % 24 +8);
        }

        function getMinute(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / 60) % 60);
        }

        function getSecond(uint timestamp) public pure returns (uint8) {
                return uint8(timestamp % 60);
        }

        function getWeekday(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, 0, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, minute, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
                uint16 i;

                // Year
                for (i = ORIGIN_YEAR; i < year; i++) {
                        if (isLeapYear(i)) {
                                timestamp += LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                timestamp += YEAR_IN_SECONDS;
                        }
                }

                // Month
                uint8[12] memory monthDayCounts;
                monthDayCounts[0] = 31;
                if (isLeapYear(year)) {
                        monthDayCounts[1] = 29;
                }
                else {
                        monthDayCounts[1] = 28;
                }
                monthDayCounts[2] = 31;
                monthDayCounts[3] = 30;
                monthDayCounts[4] = 31;
                monthDayCounts[5] = 30;
                monthDayCounts[6] = 31;
                monthDayCounts[7] = 31;
                monthDayCounts[8] = 30;
                monthDayCounts[9] = 31;
                monthDayCounts[10] = 30;
                monthDayCounts[11] = 31;

                for (i = 1; i < month; i++) {
                        timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
                }

                // Day
                timestamp += DAY_IN_SECONDS * (day - 1);

                // Hour
                timestamp += HOUR_IN_SECONDS * (hour);

                // Minute
                timestamp += MINUTE_IN_SECONDS * (minute);

                // Second
                timestamp += second;

                return timestamp;
        }
    
    
    
}


contract Quiz is TryGongToken {

    struct Answer{
        string text; //答案的內容 
        uint hearts; //答案的讚數
    }
    
    struct Option{
        string text; //選項的內容
        uint voteCount; //選項的投票數
    }
    
    struct Question{
        uint questionNumber;
        string questionName; //題目的主旨
        string text; //題目的內容
        string userName; //建立題目的使用者名稱
        uint time; //建立題目的時間
        uint[] answerList; //list of answer keys so we can look them up
        uint money;
        mapping(uint => Answer) answerStructs; //答案的struct，用answerNumber取得 
        uint[] optionList; 
        mapping(uint => Option) optionStructs; //選項的struct，用optionNumber取得
    }
    
    mapping(uint => Question) questionStructs; // 題目的struct，用qusetionNumber(題目編號)取得 
    uint[] questionList; // list of question keys so we can enumerate them

    //事件記得寫
    
    //建立一個新題目
    function newQuestion(string _questionName ,string _text, string _userName,uint _time, uint _money, address _manageAddress) public returns (bool success,uint id,string questionName, string text, string userNamename, uint time,uint money){
        // not checking for duplicates
        uint _questionNumber = 1 + questionList.length;
        transfer(_manageAddress, _money);
        questionStructs[_questionNumber].questionNumber = _questionNumber;
        questionStructs[_questionNumber].questionName = _questionName;
        questionStructs[_questionNumber].text = _text;
        questionStructs[_questionNumber].userName = _userName;
        questionStructs[_questionNumber].time = _time;
        questionStructs[_questionNumber].money = _money;
        questionList.push(_questionNumber);
        return(
            true,
            _questionNumber,
            _questionName,
            _text,
            _userName,
            questionStructs[_questionNumber].time,
            questionStructs[_questionNumber].money
        );
    }
    
    //回傳題目資訊
    function getQuestion(uint _questionNumber) public constant returns(string questionName, string text, string userNamename, uint time,uint money, uint optionCount, uint answerCount){
        return(
            questionStructs[_questionNumber].questionName,
            questionStructs[_questionNumber].text,
            questionStructs[_questionNumber].userName, 
            questionStructs[_questionNumber].time,
            questionStructs[_questionNumber].money,
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


