Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAD8217F37;
	Sat, 26 Oct 2024 01:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729905021; cv=none; b=vFRG4IZmA0XW07rdf/Ash6zX/keFG89/wjFg7PjaPMLTGeHjIYuYTB7EkqyUSbxqy6bKQeEEepuNnjCiHuYLCGAQPVZSiiAT7/Re6VeuEF902DhsZ34VEeITjqc6jDR7RjbGzSQMgTjKYjJME0Paux8mBGzenbDUckSbTyxyLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729905021; c=relaxed/simple;
	bh=6vLJaltGN9Gk4PM4giUiz1Tq0iNphWhHZeBSjjm+j9E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J41p9gQAmzToGBi40ijXcmn+QSBY5dBIeVOG69SAm8zHBuXhycjFCGwarBNQtk6TmeKqQuqnXS5I93Ko86L4nmpbjkUafanehIpzF/hQEqJjmp3MaMGFaaHLQC2g9EnfsHwd0NxXyBFjRq1pN6KbfHSA3UXUDF2N91YzRWwqGWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q04Tnp008973;
	Fri, 25 Oct 2024 18:09:56 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 42c8240tmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 25 Oct 2024 18:09:56 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 18:09:55 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 18:09:53 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <lizhi.xu@windriver.com>
CC: <bfoster@redhat.com>, <kent.overstreet@linux.dev>,
        <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] bcachefs: Retrieve ext again after sb is reallocated
Date: Sat, 26 Oct 2024 09:09:53 +0800
Message-ID: <20241026010953.2380726-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241025100205.635960-1-lizhi.xu@windriver.com>
References: <20241025100205.635960-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=UrgxNPwB c=1 sm=1 tr=0 ts=671c4164 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=DAUX931o1VcA:10 a=hSkVLCK3AAAA:8 a=edf1wS77AAAA:8 a=t7CeM3EgAAAA:8 a=Dmt6ulrOUtGsA1jFIwsA:9 a=cQPPKAXgyycSBL8etih5:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: iacEDTiPm0sXDT1KK4CW2Lp41WCX6QMV
X-Proofpoint-GUID: iacEDTiPm0sXDT1KK4CW2Lp41WCX6QMV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=801
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.21.0-2409260000 definitions=main-2410260008

Syzbot reported a slab-use-after-free Read in bch2_reconstruct_alloc.
The sb counters resize will cause sb reallocation and release the old sb,
which leads to uaf in ext.
After disk_sb.sb is reallocated, ext should be retrieved again to avoid uaf.

Reported-and-tested-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9fc4dac4775d07bcfe34
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/bcachefs/recovery.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 55e1504a8130..9df0969c29ce 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -59,6 +59,7 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
 
 	mutex_lock(&c->sb_lock);
 	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
+	void *sb;
 
 	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_allocations, ext->recovery_passes_required);
 	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_alloc_info, ext->recovery_passes_required);
@@ -94,7 +95,10 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
 	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
 	c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
 
+	sb = c->disk_sb.sb;
 	bch2_write_super(c);
+	if (sb != c->disk_sb.sb)
+		ext = bch2_sb_field_get(c->disk_sb.sb, ext);
 	mutex_unlock(&c->sb_lock);
 
 	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
-- 
2.43.0

