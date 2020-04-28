import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { fetchRushingStats, fetchRushingStatsCsv } from '../redux/actions'

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
  }

  handlePageBack(event) {
    this.props.fetchRushingStats(this.props.pageNum - 1, this.props.pageSize, this.props.query)
  }

  handlePageNext(event) {
    this.props.fetchRushingStats(this.props.pageNum + 1, this.props.pageSize, this.props.query)
  }

  handleQueryChange(event) {
    // go to page 1 since setting a new query
    this.props.fetchRushingStats(1, this.props.pageSize, event.target.value);
  }

  handleDownload(event) {
    this.props.fetchRushingStatsCsv(this.props.pageSize, this.props.query, 'csv')
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
        <RushingStatsTable loadingRushingStats={this.props.loadingRushingStats} rushingStats={this.props.rushingStats} />
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
  query: PropTypes.string.isRequired,
  enableBackButton: PropTypes.bool.isRequired,
  enableNextButton: PropTypes.bool.isRequired,
  downloadingFile: PropTypes.bool.isRequired,
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
  } = rushingsReducer ||
    {
      loadingRushingStats: true,
      rushingStats: [],
      pageNum: 1,
      pageSize: 10,
      query: '',
      enableBackButton: false,
      enableNextButton: false,
      downloadingFile: false,
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
  }
}

const mapDispatchToProps = dispatch => {
  return {
    fetchRushingStats: (pageNum, pageSize, query) => dispatch(fetchRushingStats(pageNum, pageSize, query)),
    fetchRushingStatsCsv: (pageSize, query, downloadFormat) => dispatch(fetchRushingStatsCsv(pageSize, query, downloadFormat)),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(RushingStats);
