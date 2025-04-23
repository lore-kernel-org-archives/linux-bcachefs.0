Received: from plesk.hostmyservers.fr (plesk.hostmyservers.fr [45.145.164.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9362028A3EF;
	Wed, 23 Apr 2025 15:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.164.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423151; cv=none; b=WNwJsywg2rW8SkACKXa54DGUXE2nuWpiSY5ErNTdqtcHyx4kmcERHGFskVjQPzfGvXyrb1qYQtpDCcB9zUD8BQGNICvdnLvF+eF9T9GYzzyPkJzLmBKK0oNRVu9h4YdMupTwvLMzionvf2lvbYmkXiFLV+lZCJKI2Pe9lQrvaOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423151; c=relaxed/simple;
	bh=NIYBVH9kpFEZnQu4Yjso/RzDo5cDJB1ShWTh2eQv9WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwyZiSdvh65iMxNq1H31TowFls2UwkCRTjUPX/9bPe5dCp+ST1UaNQ5dkQ7cab9NiKElfggXYwNY/jWOzekeQRfp8tMH2bDw8WYYp4tfjeVJN8fJTl55BSFKM6psrUxfZiAOGnKzQ+ZM9yGLR/RQ2QPVzebbp3HkdK93/Paz1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arnaud-lcm.com; spf=pass smtp.mailfrom=arnaud-lcm.com; arc=none smtp.client-ip=45.145.164.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arnaud-lcm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arnaud-lcm.com
Received: from arnaudlcm-X570-UD.. (unknown [IPv6:2a01:e0a:3e8:c0d0:d851:318b:70da:57a7])
	by plesk.hostmyservers.fr (Postfix) with ESMTPSA id 5B9973B5463;
	Wed, 23 Apr 2025 15:45:38 +0000 (UTC)
Authentication-Results: Plesk;
	spf=pass (sender IP is 2a01:e0a:3e8:c0d0:d851:318b:70da:57a7) smtp.mailfrom=contact@arnaud-lcm.com smtp.helo=arnaudlcm-X570-UD..
Received-SPF: pass (Plesk: connection is authenticated)
From: Arnaud Lecomte <contact@arnaud-lcm.com>
To: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Sub volumes handling in bch2_fsck_update_backpointers
Date: Wed, 23 Apr 2025 17:45:31 +0200
Message-ID: <20250423154531.376838-1-contact@arnaud-lcm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6806d857.050a0220.f25bb.07a8.GAE@google.com>
References: <6806d857.050a0220.f25bb.07a8.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <174542313871.6255.12048170017684785252@Plesk>
X-PPP-Vhost: arnaud-lcm.com

Hey everyone, in fsck.c, we have:
/*
 * Prefer to delete the first one, since that will be the one at the wrong
 * offset:
 * return value: 0 -> delete k1, 1 -> delete k2
 */
int bch2_fsck_update_backpointers(struct btree_trans *trans,
				  struct snapshots_seen *s,
				  const struct bch_hash_desc desc,
				  struct bch_hash_info *hash_info,
				  struct bkey_i *new)
{
	if (new->k.type != KEY_TYPE_dirent)
		return 0;

	struct bkey_i_dirent *d = bkey_i_to_dirent(new);
	struct inode_walker target = inode_walker_init();
	int ret = 0;

	if (d->v.d_type == DT_SUBVOL) {
		BUG();
	} else {
		ret = get_visible_inodes(trans, &target, s, le64_to_cpu(d->v.d_inum));
		if (ret)
			goto err;

		darray_for_each(target.inodes, i) {
			i->inode.bi_dir_offset = d->k.p.offset;
			ret = __bch2_fsck_write_inode(trans, &i->inode);
			if (ret)
				goto err;
		}
	}
err:
	inode_walker_exit(&target);
	return ret;
}

What is the current state for handling subvolumes ? In someone already working on or it is something we don't want to implement
for some reasons ?

Regards,
Arnaud
