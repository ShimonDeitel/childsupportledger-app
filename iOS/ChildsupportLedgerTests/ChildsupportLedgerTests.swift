import XCTest
@testable import ChildsupportLedger

@MainActor
final class ChildsupportLedgerTests: XCTestCase {
    func testSeedDataIsBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.items.count
        let added = store.add(Payment())
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = Store()
        let item = Payment()
        _ = store.add(item)
        let before = store.items.count
        store.delete(item)
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testUpdateModifiesItem() {
        let store = Store()
        let item = Payment()
        _ = store.add(item)
        let updated = item
        store.update(updated)
        XCTAssertTrue(store.items.contains(where: { $0.id == item.id }))
    }

    func testFreeLimitBlocksAddWhenReached() {
        let store = Store()
        store.isPro = false
        for _ in 0..<(Store.freeLimit + 5) {
            _ = store.add(Payment())
        }
        let result = store.add(Payment())
        XCTAssertFalse(result)
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testProUserNeverHitsLimit() {
        let store = Store()
        store.isPro = true
        for _ in 0..<(Store.freeLimit + 5) {
            _ = store.add(Payment())
        }
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testDeleteAtOffsetsRemovesCorrectItem() {
        let store = Store()
        let before = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, before - 1)
    }
}
