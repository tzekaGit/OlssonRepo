
using System.Text.RegularExpressions;

namespace Mobile.Api
{
    public class JSONHelper
    {
        // Finds non-ascii and double quotes
        private static Regex nonAsciiCodepoints = new Regex(@"[""]|[^\x20-\x7f]");

        // Call this for encoding string values
        private static string encodeStringValue(string value)
        {
            return nonAsciiCodepoints.Replace(value, encodeSingleChar);
        }

        // Encodes a single character - gets called by Regex.Replace
        private static string encodeSingleChar(Match match)
        {
            return "\\u" + char.ConvertToUtf32(match.Value, 0).ToString("x4");
        }

    }
}
