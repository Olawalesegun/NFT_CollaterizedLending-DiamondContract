import "forge-std/Test.sol";
import "solidity-stringutils/strings.sol";

abstract contract DiamondUtils is Test {
    using strings for *;

    function generateSelectors(string memory _facetName) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](4);
        cmd[0] = "forge";
        cmd[1] = "inspect";
        cmd[2] = _facetName;
        cmd[3] = "methods";
        bytes memory res = vm.ffi(cmd);
        string memory st = string(res);

        strings.slice memory s = st.toSlice();
        strings.slice memory nl = "\n".toSlice();
        strings.slice memory trace = "TRACE".toSlice();
        while (s.contains(trace)) {
            s.split(nl);
        }

        strings.slice memory colon = ":".toSlice();
        strings.slice memory comma = ",".toSlice();
        strings.slice memory dbquote = '"'.toSlice();
        selectors = new bytes4[]((s.count(colon)));

        for (uint i = 0; i < selectors.length; i++) {
            s.split(dbquote);
            strings.slice memory method = s.split(colon).until(dbquote);
            selectors[i] = bytes4(method.keccak());
            strings.slice memory selectr = s.split(comma).until(dbquote);
        }
        return selectors;
    }
}
