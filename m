Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A91A700
	for <linux-bcachefs@vger.kernel.org>; Sat, 13 Jan 2024 02:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AGswIWT4"
Date: Fri, 12 Jan 2024 21:10:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705111821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ki0V0TsfW0dLMkq8BdkNrED61IwFUh4QTLFC+CxbxWM=;
	b=AGswIWT4cGjcLImP2upIMM50Pk6BWDO9fWHvx6Eo5ntXohu08fAKgfgtyq7HlA7pNEQNt7
	ejNTT/yrZRNT2kQE9Taf/1anxr9JWzN8wuERO1TJf0+n+VRqSFbR7jP1T1apgO2GuKpOpS
	uM0lP0g3zQxPhOHyMirt8m3bBKe2fjo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Parke <parke.nexus@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Bcachefs: export a different st_dev for each subvolume
Message-ID: <f5m4movuxtm7nnzowmkofb73oipkwrzdxzwjm7qbflikbpwfve@4vfq2uatekea>
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
 <CAPxz1+Y1VfrPpFhvbi=5-qgBnyMApN8r83kC-h8Q4J2DhtCHbg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPxz1+Y1VfrPpFhvbi=5-qgBnyMApN8r83kC-h8Q4J2DhtCHbg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 12, 2024 at 01:07:24PM -0800, Parke wrote:
> I asked this question back in October of 2023, but I don't know how to
> check if per-subvolume st_dev numbers have been implemented yet, so
> I'm going to ask again.
> 
> On Wed, Oct 18, 2023 at 12:37 PM Parke <parke.nexus@gmail.com> wrote:
> > In searching the linux-bcachefs mailing list, I found a post by Kent Overstreet:
> >
> > On 4 Nov 2021, Kent Overstreet wrote:
> > Still todo:
> >    - need to export a different st_dev for each subvolume, like btrfs, so that
> >      find -xdev does what you want and skips snapshots
> >
> > Source:
> > https://lore.kernel.org/linux-bcachefs/YYQZ+QmATIgKfzZ8@moria.home.lan/
> >
> > What is the status of the above todo item regarding a distinct st_dev
> > value for each subvolume?

We're going to be working on adding a volume id to statx :)
