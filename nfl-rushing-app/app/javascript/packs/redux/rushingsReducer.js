import {
  FETCH_RUSHING_STATS,
  COMPLETED_FETCH_RUSHING_STATS,
} from './actions'

function rushingStatsByPlayer(state = {
    loadingRushingStats: true,
    rushingStats: [],
    pageNum: 1,
    pageSize: 10,
    query: '',
  },
  action
) {
  switch (action.type) {
    case FETCH_RUSHING_STATS:
      return Object.assign({}, state, {
        rushingStats: [],
        loadingRushingStats: false,
        pageNum: action.pageNum,
        pageSize: action.pageSize,
        query: action.query,
      })
    case COMPLETED_FETCH_RUSHING_STATS:
      return Object.assign({}, state, {
        rushingStats: action.rushingStats,
        loadingRushingStats: false,
      })
    default:
      return state
  }
}

export default rushingStatsByPlayer
