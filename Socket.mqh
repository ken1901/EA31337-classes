//+------------------------------------------------------------------+
//|                                                EA31337 framework |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

/**
 * @file
 * Implements class for socket connection.
 */

/**
 * Socket class.
 */
class Socket {
 protected:
  // Target machine address. E.g., "localhost" or "127.0.0.1"
  string address;

  // Target machine port. E.g., 8080.
  int port;

  // Stores default timeout used for socket connection.
  int timeout;

  // Stores default number of retries used for socket connection.
  int num_retries;

  // Socket identifier.
  int socket;

  // Whether connection has been estabilished using TLS handshake.
  bool is_tls;

 public:
  /**
   * Constructor.
   */
  Socket() : is_tls(false), socket(INVALID_HANDLE) {}

  /**
   * Destructor.
   */
  ~Socket() {
    if (socket != INVALID_HANDLE) {
      SocketClose(socket);
    }
  }

  /**
   * Makes a socket connection to the target machine.
   */
  bool Connect(const string _address, const int _port = 0, const int _timeout = 3000, int _num_retries = 5) {
    timeout = _timeout;
    num_retries = _num_retries;

    if (socket != INVALID_HANDLE) {
      // Socket already connected?
      if (IsConnected() && _address == address && port == _port) {
        // Already connected to given address and port. Nothing to do.
        return true;
      } else {
        SocketClose(socket);
        socket = INVALID_HANDLE;
      }
    } else {
      // Invalid socket, creating new one.
      socket = SocketCreate();

      int last_error = GetLastError();

      if (last_error == 4014) {
        Alert("Cannot create socket: ", "Socket can be created only from Expert Advisors and scripts!");
      } else if (socket == -1) {
        Alert("Cannot create socket: Error ", last_error);
      }

      if (last_error != 0) {
        // Someting bad happened and socket cannot be created.
        return false;
      }
    }

    // Trying to connect to the given address and port.
    while (_num_retries-- > 0) {
      if (SocketConnect(socket, _address, _port, _timeout)) {
        break;
      }
    }

    if (!IsConnected()) {
      // Cannot connect. Giving up.
      return false;
    }

    // Checking if connection is over TLS.
    string subject, issuer, serial, thumbprint;
    datetime expiration;
    is_tls = SocketTlsCertificate(socket, subject, issuer, serial, thumbprint, expiration);

    return true;
  }

  /**
   * Checks whether socket is still connected to the target machine.
   */
  bool IsConnected() const { return SocketIsConnected(socket); }

  /**
   * Ensures socket connection is still active. Returns false if connection cannot be reestabilished.
   */
  bool EnsureConnected() {
    if (!IsConnected()) {
      if (!Connect(address, port, timeout, num_retries)) {
        return false;
      }
    }

    return true;
  }

  /**
   * Sends string through the socket.
   */
  bool Send(const string text) {
    unsigned char _buffer[];
    int _buffer_length = StringToCharArray(text, _buffer, 0, WHOLE_ARRAY, CP_UTF8);
    return Send(_buffer, _buffer_length);
  }

  /**
   * Sends bytes through the socket.
   */
  bool Send(const unsigned char& _buffer[], unsigned int _buffer_length) {
    if (!EnsureConnected()) {
      return false;
    }

    if (is_tls) {
      return SocketTlsSend(socket, _buffer, _buffer_length) != -1;
    } else {
      return SocketSend(socket, _buffer, _buffer_length) != -1;
    }
  }

  /**
   * Reads string from the socket. Awaits given miliseconds before giving up.
   */
  string ReadString(int _timeout_ms = 1000) {
    if (!EnsureConnected()) {
      return NULL;
    }

    string text = "";
    unsigned int _data_length;
    unsigned char _buffer[];

    while ((_data_length = SocketIsReadable(socket)) > 0) {
      if (!Read(_buffer, _data_length, _timeout_ms)) {
        return "";
      }

      text += CharArrayToString(_buffer, 0, WHOLE_ARRAY, CP_UTF8);
    }

    return text;
  }

  /**
   * Reads bytes from the socket. Awaits given miliseconds before giving up.
   */
  bool Read(unsigned char& _buffer[], unsigned int _buffer_max_length, unsigned int _timeout_ms = 1000) {
    if (!EnsureConnected()) {
      return false;
    }

    if (is_tls) {
      return SocketTlsRead(socket, _buffer, _buffer_max_length) != -1;
    } else {
      return SocketRead(socket, _buffer, _buffer_max_length, _timeout_ms) != -1;
    }
  }
};
