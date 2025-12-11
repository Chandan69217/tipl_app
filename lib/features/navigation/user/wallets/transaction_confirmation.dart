enum TransactionStatus {
  pending,
  success,
  failed,
}

TransactionStatus parseStatus(String status) {
  switch (status.toLowerCase()) {
    case 'success':
      return TransactionStatus.success;
    case 'failed':
      return TransactionStatus.failed;
    default:
      return TransactionStatus.pending;
  }
}
