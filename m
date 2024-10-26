Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1781D1632ED;
	Sat, 26 Oct 2024 04:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729916374; cv=none; b=YA3JiQCx7hgllysDgFPsch7XJSaFmcinKSmj2xtVAqHC/C4yCqQT1o9L85bagjZk9LAyNhuRHikzHmEK17xUQAEsd+jI8yGNheC8LXYpXbzuMyUW5RS/LBlFXo72+aDc6lTGQG7aaGKO4oDIeh9P+eLMStV7MQ004uhmhoeCFjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729916374; c=relaxed/simple;
	bh=tT7oOs94GFXNS3vZEgJoUyI6YLrituu01LE1dAuibT0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yy93mEGi6Pb/3yj0NufMuRpOOJiGbhsn2L8t4te/RuBWwqfNXwisSfAPFrmTU4ZytElp3vJpujzLZ+BT0RGRbRvgD3ABDngIxAgwUwlZ6Nzz3jdeGmhK4oClxxWeBxJckDV//hoxyZhwDSoFEZfZJC1lwMLxMXxMaAcsiNRldlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q4Bnub016958;
	Sat, 26 Oct 2024 04:19:12 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 42gnn0r5v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 26 Oct 2024 04:19:12 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 21:19:11 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 21:19:09 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH] bcachefs: Retrieve ext again after sb is reallocated
Date: Sat, 26 Oct 2024 12:19:08 +0800
Message-ID: <20241026041908.2739593-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <43c3r56uapoeyc33lt6tunn5x772ngflxq6lpntodoj3g32s6t@ohktx3g4pkis>
References: <43c3r56uapoeyc33lt6tunn5x772ngflxq6lpntodoj3g32s6t@ohktx3g4pkis>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZIuFmm7b c=1 sm=1 tr=0 ts=671c6dc0 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=DAUX931o1VcA:10 a=hSkVLCK3AAAA:8 a=edf1wS77AAAA:8 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=tUeG7FvVIi3DSfVR994A:9 a=cQPPKAXgyycSBL8etih5:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: sDrdc5-nCGP5fM8Ivs6NjWuhAYxCC3Qc
X-Proofpoint-ORIG-GUID: sDrdc5-nCGP5fM8Ivs6NjWuhAYxCC3Qc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.21.0-2409260000 definitions=main-2410260033

On Fri, 25 Oct 2024 21:17:09 -0400, Kent Overstreet wrote:
> On Sat, Oct 26, 2024 at 09:09:53AM +0800, Lizhi Xu wrote:
> > Syzbot reported a slab-use-after-free Read in bch2_reconstruct_alloc.
> > The sb counters resize will cause sb reallocation and release the old sb,
> > which leads to uaf in ext.
> > After disk_sb.sb is reallocated, ext should be retrieved again to avoid uaf.
> >
> > Reported-and-tested-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=9fc4dac4775d07bcfe34
> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > ---
> >  fs/bcachefs/recovery.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> > index 55e1504a8130..9df0969c29ce 100644
> > --- a/fs/bcachefs/recovery.c
> > +++ b/fs/bcachefs/recovery.c
> > @@ -59,6 +59,7 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
> >
> >  	mutex_lock(&c->sb_lock);
> >  	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
> > +	void *sb;
> >
> >  	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_allocations, ext->recovery_passes_required);
> >  	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_alloc_info, ext->recovery_passes_required);
> > @@ -94,7 +95,10 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
> >  	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
> >  	c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
> >
> > +	sb = c->disk_sb.sb;
> >  	bch2_write_super(c);
> > +	if (sb != c->disk_sb.sb)
> > +		ext = bch2_sb_field_get(c->disk_sb.sb, ext);
> >  	mutex_unlock(&c->sb_lock);
> >
> >  	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
> 
> There's a simpler fix:
> 
> 
> From 8e910ca20e112d7f06ba3bf631a06ddb5ce14657 Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kent.overstreet@linux.dev>
> Date: Fri, 25 Oct 2024 13:13:05 -0400
> Subject: [PATCH] bcachefs: Fix UAF in bch2_reconstruct_alloc()
> 
> write_super() -> sb_counters_from_cpu() may reallocate the superblock
> 
> Reported-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 454b5a32dd7f..0ebc76dd7eb5 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -94,11 +94,10 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
>  	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
>  	c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
> 
> -	bch2_write_super(c);
> -	mutex_unlock(&c->sb_lock);
> -
>  	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
> 
> +	bch2_write_super(c);
> +	mutex_unlock(&c->sb_lock);
> 
>  	bch2_shoot_down_journal_keys(c, BTREE_ID_alloc,
>  				     0, BTREE_MAX_DEPTH, POS_MIN, SPOS_MAX);
Oh, Yes, it can fix, but my first fix is before your patch,

https://lore.kernel.org/all/20241025100205.635960-1-lizhi.xu@windriver.com/

Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_reconstruct_alloc
Date: Fri, 25 Oct 2024 18:02:05 +0800	[thread overview]
Message-ID: <20241025100205.635960-1-lizhi.xu@windriver.com> (raw)
In-Reply-To: <671907d4.050a0220.1e4b4d.008f.GAE@google.com>

The counters will cause sb to be realloc and release the old sb, which leads to uaf in ext

#syz test: upstream master

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
