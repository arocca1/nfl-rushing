import {
  FETCH_RUSHING_STATS,
  COMPLETED_FETCH_RUSHING_STATS,
  DOWNLOAD_RUSHING_FILE,
  COMPLETED_DOWNLOAD_RUSHING_FILE,
} from './actions'

function rushingStatsByPlayer(state = {
    loadingRushingStats: true,
    rushingStats: [],
    pageNum: 1,
    pageSize: 10,
    query: '',
    enableBackButton: false,
    enableNextButton: false,
    downloadingFile: false,
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
        enableBackButton: action.enableBackButton,
        enableNextButton: action.enableNextButton,
      })
    case COMPLETED_FETCH_RUSHING_STATS:
      return Object.assign({}, state, {
        rushingStats: action.rushingStats,
        loadingRushingStats: false,
        enableBackButton: action.enableBackButton,
        enableNextButton: action.enableNextButton,
      })
    case DOWNLOAD_RUSHING_FILE:
    case COMPLETED_DOWNLOAD_RUSHING_FILE:
      return Object.assign({}, state, {
        downloadingFile: action.downloadingFile,
      })
    default:
      return state
  }
}

export default rushingStatsByPlayer
