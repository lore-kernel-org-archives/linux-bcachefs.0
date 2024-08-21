Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18F81803E;
	Wed, 21 Aug 2024 03:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724211076; cv=none; b=GR2jKFfKAlbSsnybLgJzET0MCXY6KpnZXHnCjPQ1k5qBbKFnFFJLgwHN347biOxEYGuDfvrQ4y9Tkoz5pvMKO82tLTtY+bSEQ9rb7y65NxAiIToAobNBtzuwG4KHsZra6RjErN3lJ7G3i0LIyeK35oBQ94BCM6JFcMbSC/FW9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724211076; c=relaxed/simple;
	bh=ULGGJTYhv2rwWZc4fenX5GKTGSd0gEW+tpujNdJUQdU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nHMYc3VlkJDs2w0nv55Ol7YgY0wx7uX63h/QWBbP38cJw0SW13XFmyKDCuzPLtNYkzqbkou/wvCCbyAgv95q6ZmqES0djA/Ce8Go/PnAmEhp+waOSU2ciTVLmPMJr3FVkIOOfgMm0FAMNoxSC+Bdt4moMsP032nA9v2JRYQqNsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L3UUuD022800;
	Wed, 21 Aug 2024 03:31:04 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412ju6unmu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 21 Aug 2024 03:31:04 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 20:31:02 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 20:31:00 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizhi.xu@windriver.com>,
        <syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH V3] bcachefs: Add journal v2 entry nr value check
Date: Wed, 21 Aug 2024 11:30:59 +0800
Message-ID: <20240821033059.2244258-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <vr4n6n25sq5dtcr3njl44ev2dxrawpz6s6xwv6cpjfm33uqmay@uhieqhcxeuns>
References: <vr4n6n25sq5dtcr3njl44ev2dxrawpz6s6xwv6cpjfm33uqmay@uhieqhcxeuns>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ywKoFpMpWX82AjYd9oAP2yhNPsI6gLuo
X-Authority-Analysis: v=2.4 cv=VdWlP0p9 c=1 sm=1 tr=0 ts=66c55f78 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=e9QManfWWoWEGbeKLPEA:9 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: ywKoFpMpWX82AjYd9oAP2yhNPsI6gLuo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_03,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408210023

On Tue, 20 Aug 2024 23:16:50 -0400, Lizhi Xu wrote:
> > On Tue, 20 Aug 2024 23:00:05 -0400, Kent Overstreet wrote:
> > > > When the nr value of a signle entry or their sum overflows, it will
> > > > cause the value of ja->nr to be incorrect, this will result in the
> > > > allocated memory to ja->buckets being too small, leading to out of
> > > > bounds access in bch2_dev_journal_init.
> > > >
> > > > Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
> > > > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > > > ---
> > > >  fs/bcachefs/journal_sb.c | 16 +++++++++++++++-
> > > >  1 file changed, 15 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/bcachefs/journal_sb.c b/fs/bcachefs/journal_sb.c
> > > > index db80e506e3ab..230ed99130e4 100644
> > > > --- a/fs/bcachefs/journal_sb.c
> > > > +++ b/fs/bcachefs/journal_sb.c
> > > > @@ -107,6 +107,7 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
> > > >  	unsigned nr;
> > > >  	unsigned i;
> > > >  	struct u64_range *b;
> > > > +	u64 total_nr = 0, entry_nr;
> > > >
> > > >  	nr = bch2_sb_field_journal_v2_nr_entries(journal);
> > > >  	if (!nr)
> > > > @@ -117,8 +118,21 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
> > > >  		return -BCH_ERR_ENOMEM_sb_journal_v2_validate;
> > > >
> > > >  	for (i = 0; i < nr; i++) {
> > > > +		entry_nr = le64_to_cpu(journal->d[i].nr);
> > > > +		if (entry_nr > UINT_MAX) {
> > > > +			prt_printf(err, "Journal v2 entry d[%u] nr %llu overflow\n",
> > > > +				i, entry_nr);
> > > > +			goto err;
> > > > +		}
> > >
> > > This check is unnecessary; we know the sum can't overflow a u64 because
> > > we're also checking that the entries are nonoverlapping.
> > You didn't read my previous email carefully.
> > In this issue, journal->d[0] is 7, journal->d[1] is 18446744073709551615,
> > so the sum of their u64 type values will definitely overflow.
> 
> It doesn't matter. We're already checking that the entries are
> nonoverlapping, and within the range of [1, nbuckets), so total_nr can't
> overflow nbuckets, much less an s64 (not that that matters).
Are you sure? Or did I not express myself clearly? See the actual running results below:
le64_to_cpu(journal->d[1].nr) + le64_to_cpu(journal->d[0].nr) = 7 + 18446744073709551615 will overflow.

When a u64 overflow occurs, total_nr will not be greater than UINT_MAX,
so it is not enough to only calculate the total nr of entry to determine.

Note: u64 contains 0 ~ 18446744073709551616.

BR,
Lizhi
