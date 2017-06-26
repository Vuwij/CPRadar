#ifndef DATAREADER_H
#define DATAREADER_H

#include "Bytes.hpp"
#include "Data.hpp"
#include "datatypes.h"
#include <string>
#include <memory>
#include <cinttypes>

namespace XeThru {

/**
 * @class DataReader
 *
 * The DataReader class allows reading of xethru data records from a recording generated by
 * \ref DataRecorder.
 *
 * The DataReader class is a high level reader class. It can be used to read all data records
 * stored on disk by the \a DataRecorder class. From the user's point of view the recording
 * appears as one big file even if the recording may contain several files and folders on disk.
 *
 * Data returned from this class is always aligned on complete data records as specified by
 * the Xethru File Formats document for a given \ref DataType.
 *
 * @snippet read_recording.cpp Typical usage
 *
 * @note Use *xethru_recording_meta.dat* as input argument to \ref open. This file contains
 * all required information for a particular recording.
 *
 * In some cases it might be more desirable to read records directly into a raw buffer. In such
 * case it is *important* to note that if the buffer is not big enough to hold the entire record,
 * the buffer will contain an incomplete record. Use \ref get_max_record_size to avoid this:
 *
 * @snippet read_recording.cpp Typical usage with raw buffer
 *
 * @see DataRecorder, DataPlayer
 */
class DataReaderPrivate;
class DataReader
{
public:
    /**
     * Constructs reader.
     */
    DataReader();

    /**
     * Destroys the reader.
     */
    ~DataReader();

    /**
     * Opens a recording specified by the given meta filename. One recording may contain several meta files,
     * for example as a result of file/directory splitting. The meta file contains information about which files
     * and data types were written to disk during a recording session. Common for all use cases is that
     * *xethru_recording_meta.dat* is always present in the output folder generated by \a DataRecorder. Use that file
     * as input argument to this function.
     * @param meta_filename Specifies which recording (*xethru_recording_meta.dat*) to open
     * @param depth Specifies the number of meta files to open in 'chained mode'.
     * By default, this parameter is -1 (automatically open all files, i.e. the entire recording).
     * @return 0 on success, otherwise returns 1
     * @see read_record
     */
    int open(const std::string &meta_filename, int depth = -1);

    /**
     * @return true if the recording is successfully opened, otherwise returns false
     * @see open
     */
    bool is_open() const;

    /**
     * Closes all meta files and data files opened by this class.
     * @see open
     */
    void close();

    /**
     * @return true if no more data records is available for reading, otherwise returns false.
     * @see open, read_record
     */
    bool at_end() const;

    /**
     * Reads at most max_size bytes from disk into \a data and updates the output parameters.
     *
     * Upon success, \a data contains a complete record as stored on disk for a particular
     * data type. The format is specified by the Xethru File Formats document unless \a is_user_header
     * is true. In such case \a data contains custom user header as supplied by the user
     * (see \a RecordingOptions::set_user_header).
     *
     * Reading past the end is considered an error. Thus, always check \ref at_end() before
     * calling this function.
     *
     * @param[out] data Specifies the buffer to read data into.
     * @param[in] max_size Specifies the maximum number of bytes to read.
     * @param[out] size Specifies the actual number of bytes read.
     * @param[out] data_type Specifies the \ref DataType for the record.
     * @param[out] epoch Specifies the date/time the record was written to disk as number of milliseconds since 1970.01.01.
     * @param[out] is_user_header Set to true if the record is custom user header; otherwise false.
     * @return 0 on success, otherwise returns 1.
     * @see at_end, set_filter, get_max_record_size
     */
    int read_record(uint8_t *data, uint32_t max_size,
                    uint32_t *size, uint32_t *data_type,
                    int64_t *epoch, uint8_t *is_user_header);

    /**
     * Reads all bytes from a data record on disk and returns the DataRecord.
     *
     * This is a convenience method that ensures all bytes from a record is read.
     *
     * This method has no way of reporting error, however \a DataRecord::is_valid is set
     * to true on success; otherwise set to false.
     *
     * @return the DataRecord.
     * @see at_end, set_filter
     */
    DataRecord read_record();

    /**
     * Reads at most max_size bytes from disk into \a data and updates the output parameters
     * without side effects (i.e. if you call read after peek it will return the same data).
     *
     * Upon success, \a data contains a complete record as stored on disk for a particular
     * data type. The format is specified by the Xethru File Formats document unless \a is_user_header
     * is true. In such case \a data contains custom user header as supplied by the user
     * (see \a RecordingOptions::set_user_header).
     *
     * Reading past the end is considered an error. Thus, always check \ref at_end() before
     * calling this function.
     *
     * @param[out] data Specifies the buffer to read data into.
     * @param[in] max_size Specifies the maximum number of bytes to read.
     * @param[out] size Specifies the actual number of bytes read.
     * @param[out] data_type Specifies the \ref DataType for the record.
     * @param[out] epoch Specifies the date/time the record was written to disk as number of milliseconds since 1970.01.01.
     * @param[out] is_user_header Set to true if the record is custom user header; otherwise false.
     * @return 0 on success, otherwise returns 1.
     * @see read_record, at_end, set_filter, get_max_record_size
     */
    int peek_record(uint8_t *data, uint32_t max_size,
                    uint32_t *size, uint32_t *data_type,
                    int64_t *epoch, uint8_t *is_user_header);

    /**
     * Reads all bytes from a data record on disk and returns the DataRecord without side effects
     *  (i.e. if you call read after peek it will return the same data).
     *
     * This is a convenience method that ensures all bytes from a record is read.
     *
     * This method has no way of reporting error, however \a DataRecord::is_valid is set
     * to true on success; otherwise set to false.
     *
     * @return the DataRecord.
     * @see read_record, at_end, set_filter
     */
    DataRecord peek_record();

    /**
     * Sets the current position as specified.
     * @param position Specifies the position as number of milliseconds.
     * @return 0 on success, otherwise returns 1
     * @see seek_byte, get_duration, at_end
     */
    int seek_ms(int64_t position);

    /**
     * Sets the current position as specified.
     * @param position Specifies the position as number of bytes.
     * @return 0 on success, otherwise returns 1
     * @see seek_ms, get_size, at_end
     */
    int seek_byte(int64_t position);

    /**
     * Sets the filter used by \ref read_record and \ref peek_record. The filter is used to specify the kind
     * of data records returned by \ref read_record and \ref peek_record.
     *
     * By default, the filter is set to all data types.
     *
     * @param data_types Specifies the filter as a bitmask that consists of a combination of \ref DataType flags.
     * These flags can be combined with the bitwise OR operator (|). For example: BasebandIqDataType | SleepDataType.
     * A convenience value \ref AllDataTypes can also be specified.
     *
     * @return 0 success, otherwise returns 1
     * @see read_record, peek_record
     */
    int set_filter(uint32_t data_types);

    /**
     * @return the filter used by \ref read_record and \ref peek_record. By default this value is all data types.
     * @see set_filter
     */
    uint32_t get_filter() const;

    /**
     * @return the start date/time for the recording as number of milliseconds since 1970.01.01.
     * @see get_size
     */
    int64_t get_start_epoch() const;

    /**
     * @return the total duration of the recording as milliseconds.
     * @see get_start_epoch
     */
    int64_t get_duration() const;

    /**
     * @return the total size of the recording as number of bytes.
     */
    int64_t get_size() const;

    /**
     * This function returns a bitmask of all data types included in the recording.
     * The bitmask is an OR combination of \ref DataType flags.
     * For example: BasebandIqDataType | SleepDataType.
     *
     * @return a bitmask of all data types included in the recording.
     *
     */
    uint32_t get_data_types() const;

    /**
     * @return the number of bytes of the largest record on disk included in the recording.
     * @see read_record
     */
    uint32_t get_max_record_size() const;

    /**
     * @return the session id for the recording.
     * @see RecordingOptions::set_session_id
     */
    std::string get_session_id() const;

    /**
     * @return the version number of the meta file format.
     */
    uint32_t get_meta_version() const;

private:
    DataReader(const DataReader &other) = delete;
    DataReader(DataReader &&other) = delete;
    DataReader& operator= (const DataReader &other) = delete;
    DataReader& operator= (DataReader &&other) = delete;

    std::unique_ptr<DataReaderPrivate> d_ptr;
};

} // namespace XeThru

#endif // DATAREADER_H