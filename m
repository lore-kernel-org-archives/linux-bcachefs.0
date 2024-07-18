Received: from bilby.grue.cc (li1738-184.members.linode.com [172.104.158.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7373115C9;
	Thu, 18 Jul 2024 01:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.158.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721266270; cv=none; b=ac/N+qbAveJHVEu1jES1vbLoG6arEBDDUiqMdxotZkGaE4kp8x4TlGZJ0p508cvwbJM/UyUl016tf9jzKK1DosCQJXXi7PQ36VxqN3mKUJ6zMTcZlkmRTslc6oRU2ky7JhKi0e4CbkXTVCvgYP409Jk1lidgk9hmblnVV+OleXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721266270; c=relaxed/simple;
	bh=PAusxqMuKuujOlgNEGGswtWoNAiTQ764ufrq2g1OL2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUsQSgGCAN8ns/Ba40Je/HCf2SfujCm5TYXkvQ7jMmZNzdfg/IP9/VNENQ1DyMxeHJ2FEKlx70/FUbnjcZjKMP+Nz6Vlc9zdFl4mBArxEuxFYc6OktS9r3q+z+8jn2eJqtlZCjkRXBWprkwh6YBnD50nBK/Ujt43qoD2EmuKD58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inml.grue.cc; spf=pass smtp.mailfrom=inml.grue.cc; arc=none smtp.client-ip=172.104.158.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inml.grue.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inml.grue.cc
Received: from happy-place5.inml.grue.cc ([100.64.10.15] helo=happy-place5.inml.grue.cc)
	by bilby.grue.cc with esmtp (Exim 4.97)
	(envelope-from <lkml@inml.grue.cc>)
	id 1sUFZR-00000000PjZ-0FxC;
	Thu, 18 Jul 2024 11:04:34 +1000
Received: from hogarth by bunyip.jovian.space with local (Exim 4.97)
	(envelope-from <lkml@inml.grue.cc>)
	id 1sUFZO-0000000123Y-468t;
	Thu, 18 Jul 2024 11:04:31 +1000
Date: Thu, 18 Jul 2024 11:04:30 +1000
From: AP <lkml@inml.grue.cc>
To: Camila Alvarez <cam.alvarez.i@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
Message-ID: <ZphqHm15yNggNdF-@inml.grue.cc>
Mail-Followup-To: AP <lkml@inml.grue.cc>,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <20240717220237.1246673-1-cam.alvarez.i@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717220237.1246673-1-cam.alvarez.i@gmail.com>

On Wed, Jul 17, 2024 at 06:02:39PM -0400, Camila Alvarez wrote:
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index 10b19791ec98..7bbbf4b149e9 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -1201,7 +1201,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>  	struct journal_replay *i, **_i;
>  	struct genradix_iter iter;
>  	bool had_entries = false;
> -	u64 last_seq = cur_seq, nr, seq;
> +        u64 last_written_seq = cur_seq - 1, last_seq = cur_seq - 1, nr, seq;

Spaces not tabs. I think consistency would be wanted so should be a tab.

AP
