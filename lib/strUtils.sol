pragma solidity '0.4.19';

library strUtils {
    string constant CANTRACK_JSON_ID = '"id":"CanTrack"';
    
    uint8 constant CANTRACK_JSON_MIN_LEN = 32;
    
    /* Converts given number to base58, limited by _maxLength symbols */
    function toBase58(uint256 _value, uint8 _maxLength) internal pure returns (string) {
        string memory letters = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
        bytes memory alphabet = bytes(letters);
        uint8 base = 58;
        uint8 len = 0;
        uint256 remainder = 0;
        bool needBreak = false;
        bytes memory bytesReversed = bytes(new string(_maxLength));

        for (uint8 i = 0; i < _maxLength; i++) {
            if(_value < base){
                needBreak = true;
            }
            remainder = _value % base;
            _value = uint256(_value / base);
            bytesReversed[i] = alphabet[remainder];
            len++;
            if(needBreak){
                break;
            }
        }

        // Reverse
        bytes memory result = bytes(new string(len));
        for (i = 0; i < len; i++) {
            result[i] = bytesReversed[len - i - 1];
        }
        
        return string(result);
    }

    /* Concatenates two strings */
    function concat(string _s1, string _s2) internal pure returns (string) {
        bytes memory bs1 = bytes(_s1);
        bytes memory bs2 = bytes(_s2);
        string memory s3 = new string(bs1.length + bs2.length);
        bytes memory bs3 = bytes(s3);

        uint256 j = 0;
        for (uint256 i = 0; i < bs1.length; i++) {
            bs3[j++] = bs1[i];
        }
        for (i = 0; i < bs2.length; i++) {
            bs3[j++] = bs2[i];
        }

        return string(bs3);
    }

    /* Checks if provided JSON string has valid CanTrack format */
    function isValidJson(string _json) internal pure returns (bool) {
        bytes memory json = bytes(_json);
        bytes memory id = bytes(CANTRACK_JSON_ID);

        if (json.length < CANTRACK_JSON_MIN_LEN) {
            return false;
        } else {
            uint len = 0;
            
            if (json[1] == id[0]) {
                len = 1;
                while (len < id.length && (1 + len) < json.length && json[1 + len] == id[len]) {
                    len++;
                }
                if (len == id.length) {
                    return true;
                }
            }
        }

        return false;
    }
}