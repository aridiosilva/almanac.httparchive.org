#standardSQL

# <meta description> length

# dataset: `httparchive.lighthouse.2019_07_01_mobile`
# sample: `httparchive.almanac.lighthouse_mobile_1k`

CREATE TEMP FUNCTION analyse(payload STRING)
RETURNS BOOL
LANGUAGE js AS """
try {
  var $ = JSON.parse(payload);
  var almanac = JSON.parse($._almanac);
  if(almanac && almanac['meta-nodes']) {
        var viewportFound = almanac['meta-nodes'].findIndex(node => {
            if(node.name && node.content && node.name.toLowerCase() == 'viewport' && node.content.match(/(user-scalable=no|maximum-scale=1.0)/i)) {
                return true;
            }
        });
        return viewportFound >= 0 ? true : false
  }
  return null;
} catch (e) {
  return null;
}
""";


SELECT
    COUNT(url) as url,
    COUNTIF(analyse(payload)) as noScalelableViewport,
    (COUNTIF(analyse(payload)) / COUNT(url)) as `scorePercentage`
FROM
    `httparchive.almanac.pages_desktop_1k`
