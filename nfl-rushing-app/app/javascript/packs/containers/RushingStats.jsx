import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { fetchRushingStats } from '../redux/actions'

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
    this.props.fetchRushingStats(this.props.pageNum, this.props.pageSize, event.target.value);
  }

  handleDownload(event) {

    // TODO handle download

  }

// maybe use componentDidReceiveProps to kick off requests

  componentDidMount() {
    // initial fetch
    this.props.fetchRushingStats(this.props.pageNum, this.props.pageSize, this.props.query);
  }

  render() {
    const disabledPrevious = this.props.loadingRushingStats || !this.props.enableBackButton;
    const disabledNext = this.props.loadingRushingStats || !this.props.enableNextButton;

    return (
      <div key="RushingStats">
        <label>Player name:
          <input type="text" onChange={this.handleQueryChange} />
        </label>
        <Button variant="secondary">Download</Button>
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
  enableBackButton: false,
  enableNextButton: false,
}

RushingStats.propTypes = {
  loadingRushingStats: PropTypes.bool.isRequired,
  rushingStats: PropTypes.array,
  pageNum: PropTypes.number.isRequired,
  pageSize: PropTypes.number.isRequired,
  query: PropTypes.string.isRequired,
  enableBackButton: PropTypes.bool.isRequired,
  enableNextButton: PropTypes.bool.isRequired,
}

const mapStateToProps = (state) => {
  const { rushingsReducer } = state
  const {
    loadingRushingStats,
    rushingStats,
    pageNum,
    pageSize,
    query,
  } = rushingsReducer ||
    {
      loadingRushingStats: true,
      rushingStats: [],
      pageNum: 1,
      pageSize: 10,
      query: '',
    }
  return {
    loadingRushingStats,
    rushingStats,
    pageNum,
    pageSize,
    query,
  }
}

const mapDispatchToProps = dispatch => {
  return {
    fetchRushingStats: (pageNum, pageSize, query) => dispatch(fetchRushingStats(pageNum, pageSize, query))
  }
}

export default connect(mapStateToProps)(RushingStats);