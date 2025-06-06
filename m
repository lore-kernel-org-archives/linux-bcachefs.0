Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A871DFFC
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Jun 2025 01:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749172730; cv=none; b=T1dVEtV4IbI8wfOA7dw5WCqjerzq3Sl/mD80OAaGhhMjgLQzYd6eETzb/viFKCPBDQwjLjLpCoIb8/MhD0lyZCrKCtp4Xd6hesO9VyALPqHR7s1tf1DXpSBRUi8PnQRLC6f+e8ei+hlR6iJGa/UDdUZBaHxoWzXVq4UZNx4rO6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749172730; c=relaxed/simple;
	bh=8c1Dq6yT3t9x0Dpj+HGZJL5q2uw2BAMSBFVXwKUpj/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcHzaVQwHk1L2xQJd5ULe4QX0NwCKhAJDguGrY5a3CreBRRtsvLxGWdNJdQQJYUvj/DA9zgBFTnvHUurCc+ENFtUDTPLfqROh9qf+TesgHZ/faxgfdVdEYFhBZJqLfdjVVLxHOCTTaAE/NdNhPjFvmvd++/Ece6OE1kCcErhg90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JP83mbLo; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JP83mbLo"
Date: Thu, 5 Jun 2025 21:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749172724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rO2tIJjBj1P6RTOe001uTwwkEbfQcWt6GxngmVdOyKo=;
	b=JP83mbLoesEq070tA+hsQd/AeSanSJNQvy82wW8ZJiiwz4DzxQ9Tmwvb0GhGxhZNVTuaDY
	LhjUQMu4rFEcncRsbIOpyuShbba6T3T09qyZ5oZLlMuR7KUh/e3mqt+EMaY5huhSwmT/TJ
	l9JB1HSLv5cxtzgYDUuv/G0q+oQOmK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, 
	Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Message-ID: <7bw37fljiqfg25vd562uhf6zcj4kjqxpnifts2nkufq5uqghox@t4hwjmpdyzel>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
 <74199382-7c0f-440c-b7b6-45eabc95e332@huawei.com>
 <bhuiydsd4ovig4i2inltu4a325c35xc4zaxyaawdfrjzghgbtr@muphmxvcw7lq>
 <b7f8d9ea-36eb-4647-b238-615d7416a89b@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7f8d9ea-36eb-4647-b238-615d7416a89b@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 06, 2025 at 09:16:12AM +0800, Hongbo Li wrote:
> 
> 
> On 2025/5/31 23:03, Kent Overstreet wrote:
> > On Sat, May 31, 2025 at 10:00:55PM +0800, Hongbo Li wrote:
> > > 
> > > 在 2025/5/31 7:16, Kent Overstreet 写道:
> > > > On Fri, May 30, 2025 at 11:19:32PM +0200, Martin Steigerwald wrote:
> > > > > Hi!
> > > > > 
> > > > > Summary: I am curious why "ls -l" reports 16 EiB as the size of a
> > > > > directory entry. As to what I can see the filesystem is perfectly fine.
> > > > > 
> > > > > Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM.
> > > > > Checksums are xxhash. Filesystem was created recently on self compiled
> > > > > 6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2. "bcachefs"
> > > > > reports 1.25.1 as version number.
> > > > > 
> > > > > I have a directory entry that according to ls -l is quite big:
> > > > > 
> > > > > drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
> > > > Yes, this is due to a leftover from the directory i_size patchset that
> > > > had to be reverted. As long as it's not causing issues it'll be a bit
> > > > before I get to it, I've got higher priority bugs I'm working on right
> > > > now (as usual).
> > > > 
> > > > Hongbo, whatever happened to that patchset? I thought you were going to
> > > > fix it so we could get it back in later?
> > > I'm very sorry for the directory i_size problem. And this work has been
> > > postponed recently due to my other internal works. Yeah, I will get back to
> > > this work after this Dragon Boat festival. I'm really sorry I haven't dealt
> > > with it sooner.
> > 
> > Ok, don't worry about it, the rest of it isn't urgent, just the i_size
> > fixes for the revert - I'll try to get that out today.
> 
> Hi, Kent,
> Thank you, I noticed you have reverted the related patch. I've been to busy
> with some internal matters recently, but I will continue to follow up on
> this task.

No rush now, let's just make sure the repair code is handling
transaction restarts correctly when it comes back :)
