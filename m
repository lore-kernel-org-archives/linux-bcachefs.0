Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F0D168C3F;
	Mon,  1 Jul 2024 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719844593; cv=none; b=Q+LZZwBQWzrfEA1Xy5JAlcaqBlyUiXyS4gfVFl6IkaSd57GSEk+Emla4jwrhvv9dNBas4g6WakE0DnXPifMNTYQz8fQsh0hL4WvQtvKETSBZHD7l2EmukdCjiiKd7nEMPXIeoXC+TOvg6m4Cq2yTwhURCgNq+Cq4vhbwVeOVYgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719844593; c=relaxed/simple;
	bh=4Zejmu5jwgS5PZhhVmRTAt0SMf/n5keGcxfejmVxlD4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvS7nYAslc70xBdZkaDyAIVkDk6OsgoZPNAv/Wj7nAI7oNolbNHmLSTX5++iC66bd6J2/cfCTOhqzXSHYJen9NBZDi4dfuvvR2/St565A/zjzrwZbAVrBrKF73L/04h3mj3JfGSq/elii8s7WmDF2uoQZ0EWrqa/WP+8Z4ipA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4614kFmt016105;
	Mon, 1 Jul 2024 07:36:09 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 402hsg1h5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 01 Jul 2024 07:36:09 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 07:36:08 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 07:36:06 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com>
CC: <bfoster@redhat.com>, <kent.overstreet@linux.dev>,
        <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] bcachefs: fix hung in bch2_fs_read_only_work
Date: Mon, 1 Jul 2024 22:36:06 +0800
Message-ID: <20240701143606.3904202-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000d4c7f4061a080a7a@google.com>
References: <000000000000d4c7f4061a080a7a@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ogDim0DivcBBcxNWboBHplX92bXR5DQq
X-Proofpoint-ORIG-GUID: ogDim0DivcBBcxNWboBHplX92bXR5DQq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_12,2024-07-01_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=895 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 clxscore=1015 impostorscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2406140001 definitions=main-2407010112

Error logs:
[ T5078] invalid journal entry, version=1.7: mi_btree_bitmap type=btree_keys in superblock: k->u64s 0, shutting down
[ T5078] invalid journal entry, version=1.7: mi_btree_bitmap type=btree_keys in superblock: k->u64s 0, shutting down
[ T5078] invalid journal entry, version=1.7: mi_btree_bitmap type=btree_keys in superblock: k->u64s 0, shutting down

When hit -BCH_ERR_fsck_errors_not_fixed in journal_entry_err, it will make
journal_entry_btree_keys_validate output too many same error log, and it will block
bch2_fs_start to release state_lock.

Reported-and-tested-by: syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/bcachefs/journal_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 492426c8d869..67c3f09162e4 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -415,6 +415,8 @@ static int journal_entry_btree_keys_validate(struct bch_fs *c,
 					       flags|BCH_VALIDATE_journal);
 		if (ret == FSCK_DELETED_KEY)
 			continue;
+		else if (ret == -BCH_ERR_fsck_errors_not_fixed)
+			break;
 
 		k = bkey_next(k);
 	}
-- 
2.43.0

