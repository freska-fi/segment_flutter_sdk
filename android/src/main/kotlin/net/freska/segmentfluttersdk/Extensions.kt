package net.freska.segmentfluttersdk

/**
 * @param ifNull Function to execute if the item is null
 * @param ifNotNull Function to execute if the item is not null
 * @return [Boolean] indicating if the item is null
 */
internal fun <T> T?.whenNotNull(ifNotNull: T.() -> Unit, ifNull: (() -> Unit)? = null) {
  if (this != null) {
    ifNotNull(this)
  } else if (ifNull != null) {
    ifNull()
  }
}
