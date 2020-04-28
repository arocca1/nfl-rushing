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


// TODO determine when to make the Back and Next buttons disabled


  }
}

function receiveRushingStats(rushingStats) {
  return {
    type: COMPLETED_FETCH_RUSHING_STATS,
    rushingStats,
    loadingRushingStats: false,
  }
}

export function fetchRushingStats(pageNum, pageSize, query) {
  return dispatch => {
    dispatch(requestRushingStats(pageNum, pageSize, query))
    return axios({
        method: 'get',
        url: '/rushings/show_stats',
        baseURL: baseUrl(),
        params: {
          pageNum,
          pageSize,
          query
        }
      })
      .then(response => response.json())
      .then(json => dispatch(receiveRushingStats(json)))
  }
}
