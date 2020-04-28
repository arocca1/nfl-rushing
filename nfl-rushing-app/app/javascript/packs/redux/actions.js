import axios from 'axios'
import { baseUrl } from '../util'
import { saveAs } from 'file-saver';

export const FETCH_RUSHING_STATS = "FETCH_RUSHING_STATS";
export const COMPLETED_FETCH_RUSHING_STATS = "COMPLETED_FETCH_RUSHING_STATS";
export const DOWNLOAD_RUSHING_FILE = "DOWNLOAD_RUSHING_FILE";
export const COMPLETED_DOWNLOAD_RUSHING_FILE = "COMPLETED_DOWNLOAD_RUSHING_FILE";

function requestRushingStats(pageNum, pageSize, query, sortBy, orderDir) {
  return {
    type: FETCH_RUSHING_STATS,
    loadingRushingStats: true,
    pageNum,
    pageSize,
    query,
    enableBackButton: false,
    enableNextButton: false,
    sortBy,
    orderDir,
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

function receiveDownloadFile(downloadFormat, data) {
  saveAs(new Blob([data], {type: "text/csv;charset=utf-8"}), `rushing_stats.${downloadFormat}`)
  return {
    type: COMPLETED_DOWNLOAD_RUSHING_FILE,
    downloadingFile: false,
  }
}

function doFetchStats(pageNum, pageSize, query, downloadFormat, sortBy, orderDir) {
  let params = { query }
  if (pageNum) {
    params.page_num = pageNum
  }
  if (pageSize) {
    params.page_size = pageSize
  }
  if (sortBy) {
    params.sort_by = sortBy
  }
  if (orderDir) {
    params.order_dir = orderDir
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
      responseType: downloadFormat ? 'blob' : 'json',
    })
    .then(response => response.data)
}

export function fetchRushingStats(pageNum, pageSize, query, sortBy, orderDir) {
  return dispatch => {
    dispatch(requestRushingStats(pageNum, pageSize, query, sortBy, orderDir))
    return doFetchStats(pageNum, pageSize, query, undefined, sortBy, orderDir)
      .then(json => dispatch(receiveRushingStats(json)))
  }
}

export function fetchRushingStatsCsv(pageSize, query, downloadFormat, sortBy, orderDir) {
  return dispatch => {
    dispatch(requestDownloadStats(downloadFormat))
    return doFetchStats(undefined, pageSize, query, downloadFormat, sortBy, orderDir)
      .then(data => dispatch(receiveDownloadFile(downloadFormat, data)))
  }
}
