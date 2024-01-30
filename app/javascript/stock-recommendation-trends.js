// Data retrieved from:
// - https://en.as.com/soccer/which-teams-have-won-the-premier-league-the-most-times-n/
// - https://www.statista.com/statistics/383679/fa-cup-wins-by-team/
// - https://www.uefa.com/uefachampionsleague/history/winners/
import Highcharts from "highcharts";

document.addEventListener('DOMContentLoaded', () => {
  var recommendationTrendsEl = document.getElementById('recommendation-trends');
  if (recommendationTrendsEl) {
    var stockId = recommendationTrendsEl.dataset.stockId;

    fetch(`/stocks/${stockId}.json`)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error: ${response.status}`);
        }
        return response.json();
      })
      .then((json) => showRecommendationTrends(json))
      .catch((err) => console.error(`Fetch problem: ${err.message}`));
  }
});

function showRecommendationTrends(json) {
  let recommendationTrendsBusySpinnerEl = document.getElementById('recommendation-trends-chart-busy-spinner')
  let recommendationTrendsChartEl = document.getElementById('recommendation-trends-chart');

  let stockName = json.stock.symbol;
  let xAxis = json.recommendation_trends.map((rec) => rec.period).reverse();

  Highcharts.chart(recommendationTrendsChartEl, {
    chart: {
        type: 'column',
        backgroundColor: '#141e26',
        marginBottom: 100,
        height: 500,
        events: {
          load() {
            recommendationTrendsBusySpinnerEl.style.display = 'none';
          }
        }
    },
    title: {
        text: `${stockName} Recemmendation Trends`,
        align: 'left'
    },
    xAxis: {
        categories: xAxis
    },
    yAxis: {
        min: 0,
        title: {
            text: '# Analysts'
        },
        stackLabels: {
            enabled: true
        }
    },
    legend: {
        align: 'center',
        verticalAlign: 'bottom',
        x: 0,
        y: 0,
        floating: true,
        backgroundColor: '#141e26',
        borderColor: '#021c30',
        borderWidth: 0,
        shadow: false
    },
    tooltip: {
        headerFormat: '<b>{point.x}</b><br/>',
        pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
    },
    plotOptions: {
        column: {
            stacking: 'normal',
            dataLabels: {
                enabled: true
            }
        }
    },
    series: [{
        name: 'Buy',
        data: json.recommendation_trends.map((rec) => rec.buy).reverse()
    }, {
        name: 'Hold',
        data: json.recommendation_trends.map((rec) => rec.hold).reverse()
    }, {
        name: 'Sell',
        data: json.recommendation_trends.map((rec) => rec.sell).reverse()
    }, {
        name: 'Strong Buy',
        data: json.recommendation_trends.map((rec) => rec.strongBuy).reverse()
    }, {
        name: 'Strong Sell',
        data: json.recommendation_trends.map((rec) => rec.strongSell).reverse()
    }]
  });
}
