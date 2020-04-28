import axios from 'axios'
import { baseUrl } from '../util'

export const FETCH_RUSHING_STATS = "FETCH_RUSHING_STATS";
export const COMPLETED_FETCH_RUSHING_STATS = "COMPLETED_FETCH_RUSHING_STATS";

function requestRushingStats(pageNum, pageSize, query) {
  return {
    type: FETCH_RUSHING_STATS,
    loadingRushingStats: true,
    pageNum,
    pageSize,
    query,
    enableBackButton: false,
    enableNextButton: false,
  }
}

function receiveRushingStats(json) {
  return {
    type: COMPLETED_FETCH_RUSHING_STATS,
    loadingRushingStats: false,
    rushingStats: json.stats,
    enableBackButton: json.enable_back,
    enableNextButton: json.enable_next,
  }
}

export function fetchRushingStats(pageNum, pageSize, query) {
  return dispatch => {
    dispatch(requestRushingStats(pageNum, pageSize, query))
    return axios({
        method: 'get',
        url: '/rushing/show_stats',
        baseURL: baseUrl(),
        params: {
          page_num: pageNum,
          page_size: pageSize,
          query
        }
      })
      .then(response => response.json())
      .then(json => dispatch(receiveRushingStats(json)))
  }
}
