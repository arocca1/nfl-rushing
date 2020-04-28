import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { fetchRushingStats, fetchRushingStatsCsv } from '../redux/actions'
import { ASC_ORDER, DESC_ORDER } from '../util'

import RushingStatsTable from '../components/RushingStatsTable'

import Button from 'react-bootstrap/Button'
import ButtonGroup from 'react-bootstrap/ButtonGroup'

class RushingStats extends React.Component {
  constructor(props) {
    super(props);

    this.handlePageBack = this.handlePageBack.bind(this);
    this.handlePageNext = this.handlePageNext.bind(this);
    this.handleQueryChange = this.handleQueryChange.bind(this);
    this.handleDownload = this.handleDownload.bind(this);
    this.handleYardsSort=this.handleYardsSort.bind(this);
    this.handleTdsSort=this.handleTdsSort.bind(this);
    this.handleLongestRunSort=this.handleLongestRunSort.bind(this);
  }

  handlePageBack(event) {
    this.props.fetchRushingStats(this.props.pageNum - 1, this.props.pageSize, this.props.query, this.props.sortBy, this.props.orderDir)
  }

  handlePageNext(event) {
    this.props.fetchRushingStats(this.props.pageNum + 1, this.props.pageSize, this.props.query, this.props.sortBy, this.props.orderDir)
  }

  handleQueryChange(event) {
    // go to page 1 since setting a new query
    this.props.fetchRushingStats(1, this.props.pageSize, event.target.value, this.props.sortBy, this.props.orderDir);
  }

  handleDownload(event) {
    this.props.fetchRushingStatsCsv(this.props.pageSize, this.props.query, 'csv', this.props.sortBy, this.props.orderDir)
  }

  handleYardsSort(event) {
    // go to page 1 since setting a new column
    this.props.handleColumnSort(1, this.props.pageSize, this.props.query, this.props.sortBy, 'yards', this.props.orderDir)
  }

  handleTdsSort(event) {
    // go to page 1 since setting a new column
    this.props.handleColumnSort(1, this.props.pageSize, this.props.query, this.props.sortBy, 'tds', this.props.orderDir)
  }

  handleLongestRunSort(event) {
    // go to page 1 since setting a new column
    this.props.handleColumnSort(1, this.props.pageSize, this.props.query, this.props.sortBy, 'longest', this.props.orderDir)
  }

  componentDidMount() {
    // initial fetch
    this.props.fetchRushingStats(this.props.pageNum, this.props.pageSize, this.props.query);
  }

  render() {
    const disabledPrevious = this.props.loadingRushingStats || !this.props.enableBackButton;
    const disabledNext = this.props.loadingRushingStats || !this.props.enableNextButton;

    return (
      <div key="RushingStats">
        <label style={{'marginRight': '10px'}}>Player name:
          <input type="text" onChange={this.handleQueryChange} />
        </label>
        <Button variant="secondary" onClick={this.handleDownload} disabled={this.props.downloadingFile}>Download</Button>
        <RushingStatsTable
          loadingRushingStats={this.props.loadingRushingStats}
          rushingStats={this.props.rushingStats}
          handleYardsSort={this.handleYardsSort}
          handleTdsSort={this.handleTdsSort}
          handleLongestRunSort={this.handleLongestRunSort}
          />
        <ButtonGroup aria-label="Basic example">
          <Button variant="secondary" onClick={this.handlePageBack} disabled={disabledPrevious}>Previous</Button>
          <Button variant="secondary" onClick={this.handlePageNext} disabled={disabledNext}>Next</Button>
        </ButtonGroup>
      </div>
    )

  }
}

RushingStats.defaultProps = {
  loadingRushingStats: true,
  rushingStats: [],
  enableBackButton: false,
  enableNextButton: false,
  downloadingFile: false,
}

RushingStats.propTypes = {
  fetchRushingStats: PropTypes.func.isRequired,
  fetchRushingStatsCsv: PropTypes.func.isRequired,
  loadingRushingStats: PropTypes.bool.isRequired,
  rushingStats: PropTypes.array,
  pageNum: PropTypes.number.isRequired,
  pageSize: PropTypes.number.isRequired,
  query: PropTypes.string,
  enableBackButton: PropTypes.bool.isRequired,
  enableNextButton: PropTypes.bool.isRequired,
  downloadingFile: PropTypes.bool.isRequired,
  sortBy: PropTypes.string,
  orderDir: PropTypes.string,
  handleColumnSort: PropTypes.func.isRequired,
}

const mapStateToProps = (state) => {
  const { rushingsReducer } = state
  const {
    loadingRushingStats,
    rushingStats,
    pageNum,
    pageSize,
    query,
    enableBackButton,
    enableNextButton,
    downloadingFile,
    sortBy,
    orderDir,
  } = rushingsReducer ||
    {
      loadingRushingStats: true,
      rushingStats: [],
      pageNum: 1,
      pageSize: 10,
      query: null,
      enableBackButton: false,
      enableNextButton: false,
      downloadingFile: false,
      sortBy: null,
      orderDir: null,
    }
  return {
    loadingRushingStats,
    rushingStats,
    pageNum,
    pageSize,
    query,
    enableBackButton,
    enableNextButton,
    downloadingFile,
    sortBy,
    orderDir,
  }
}

const mapDispatchToProps = dispatch => {
  return {
    fetchRushingStats: (pageNum, pageSize, query, sortBy, orderDir) =>
      dispatch(fetchRushingStats(pageNum, pageSize, query, sortBy, orderDir)),
    fetchRushingStatsCsv: (pageSize, query, downloadFormat, sortBy, orderDir) =>
      dispatch(fetchRushingStatsCsv(pageSize, query, downloadFormat, sortBy, orderDir)),
    handleColumnSort: (pageNum, pageSize, query, previousSortBy, sortBy, previousOrderDir) => {
      let nextOrderDir = ASC_ORDER;
      // want to flip the order dir
      if (previousSortBy == sortBy) {
        nextOrderDir = previousOrderDir === ASC_ORDER ? DESC_ORDER : ASC_ORDER
      }
      dispatch(fetchRushingStats(pageNum, pageSize, query, sortBy, nextOrderDir))
    },
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(RushingStats);
