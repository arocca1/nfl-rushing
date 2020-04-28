import axios from 'axios'
import { baseUrl } from '../util'

export const FETCH_RUSHING_STATS = "FETCH_RUSHING_STATS";
export const COMPLETED_FETCH_RUSHING_STATS = "COMPLETED_FETCH_RUSHING_STATS";
export const DOWNLOAD_RUSHING_FILE = "DOWNLOAD_RUSHING_FILE";
export const COMPLETED_DOWNLOAD_RUSHING_FILE = "COMPLETED_DOWNLOAD_RUSHING_FILE";

function requestRushingStats(pageNum, pageSize, query, downloadFormat) {
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

function requestDownloadStats(downloadFormat) {
  return {
    type: DOWNLOAD_RUSHING_FILE,
    downloadFormat,
    downloadingFile: true,
  }
}

function receiveDownloadFile() {
  return {
    type: COMPLETED_DOWNLOAD_RUSHING_FILE,
    downloadingFile: false,
  }
}

function doFetchStats(pageNum, pageSize, query, downloadFormat) {
  let params = { query }
  if (pageNum) {
    params.page_num = pageNum
  }
  if (pageSize) {
    params.page_size = pageSize
  }

  return axios({
      method: 'get',
      url: '/rushing/show_stats',
      baseURL: baseUrl(),
      headers: {
        'Accept': `application/${downloadFormat || 'json'}; charset=utf-8`,
        'Content-Type': `application/${downloadFormat || 'json'}; charset=utf-8`,
      },
      params: params,
      data: {},
      //responseType: downloadFormat ? 'blob' : 'json',
    })
    .then(response => response.data)
}

export function fetchRushingStats(pageNum, pageSize, query) {
  return dispatch => {
    dispatch(requestRushingStats(pageNum, pageSize, query))
    return doFetchStats(pageNum, pageSize, query)
      .then(json => dispatch(receiveRushingStats(json)))
  }
}

export function fetchRushingStatsCsv(query, downloadFormat) {
  return dispatch => {
    dispatch(requestDownloadStats(downloadFormat))
    return doFetchStats(undefined, undefined, query, downloadFormat)
      .then(json => dispatch(receiveRushingStats()))
  }
}
