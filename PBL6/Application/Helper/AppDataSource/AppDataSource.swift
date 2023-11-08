//
//  AppDataSource.swift
//  PBL6
//
//  Created by KietKoy on 08/11/2023.
//

import UIKit
import RxDataSources

func getPreviewEventItemDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<Void, FlatEventDto>> {
    return RxCollectionViewSectionedReloadDataSource<SectionModel<Void, FlatEventDto>>(
        configureCell: {
            (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            return collectionView.dequeueReuseable(ofType: EventItemCell.self, indexPath: indexPath).apply {
                $0.configure(item: item)
            }
        }
    )
}

func getEventItemDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<Void, FlatEventDto>> {
    return RxCollectionViewSectionedReloadDataSource<SectionModel<Void, FlatEventDto>>(
        configureCell: {
            (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            return collectionView.dequeueReuseable(ofType: MyEventCell.self, indexPath: indexPath).apply {
                $0.configure(item)
            }
        }
    )
}

func getRoleItemDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<Void, EventRoleDto>> {
    return RxCollectionViewSectionedReloadDataSource<SectionModel<Void, EventRoleDto>>(
        configureCell: {
            (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            return collectionView.dequeueReuseable(ofType: RoleItemCell.self, indexPath: indexPath).apply {
                $0.configure(item)
            }
        }
    )
}

func getSpeakerItemDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<Void, BasicRepresentativeInEventDto>> {
    return RxCollectionViewSectionedReloadDataSource<SectionModel<Void, BasicRepresentativeInEventDto>>(
        configureCell: {
            (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            return collectionView.dequeueReuseable(ofType: SpeakerItemCell.self, indexPath: indexPath).apply {
                $0.configure(item)
            }
        }
    )
}

func getOrganizationItemDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<Void, OrganizationInEventDto>> {
    return RxCollectionViewSectionedReloadDataSource<SectionModel<Void, OrganizationInEventDto>>(
        configureCell: {
            (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            return collectionView.dequeueReuseable(ofType: OrganizationItemCell.self, indexPath: indexPath).apply {
                $0.configure(item)
            }
        }
    )
}

func getEventRoleItemDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<Void, EventRoleDto>> {
    return RxCollectionViewSectionedReloadDataSource<SectionModel<Void, EventRoleDto>>(
        configureCell: {
            (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            return collectionView.dequeueReuseable(ofType: RoleRegisterItemCell.self, indexPath: indexPath).apply {
                $0.configure(item)
            }
        }
    )
}
