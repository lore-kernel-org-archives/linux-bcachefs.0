Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D885863D5
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 00:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729296909; cv=none; b=KEivAx+IqZBLS+DG/YmAHP3OGUo8MyaJtIi/cRQzJTOGtcwsaOaecpERvj2+t2ooRF44+4GKGXT0mDlpvfvvE83VXVopamf3R0+3/IFSYuUdlNAjJ9IQ9HXcH3oWt8UPsnqT8evkft5NeRg1J4mRVkLY6e05NCacjqkgB5O6lS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729296909; c=relaxed/simple;
	bh=0pgDg79iF+OHbqG6dOdut7fO+hljklTgaDEDpjmXMB8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jtojDo1Qs+TMLsAMZ1m1P6dRQP3LregAZ6hDn47QtuWXMCWJO6W7Z+Fnsepr9xfDncOr9VPn2wUnLKDCwTi7RdLj9+r5+VRRCx9HUXSUE16iEnhuXGoW6E1vWOWt6FFG6FYsnG6WZ7iTuz3bTnchsGuCCPbFJOLQp+zLZKAjBQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 76AF81A2351;
	Fri, 18 Oct 2024 17:15:06 -0700 (PDT)
Date: Fri, 18 Oct 2024 17:15:06 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christopher Snowhill <chris@kode54.net>,
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <1249157619.1105.1729296906241@mail.carlthompson.net>
In-Reply-To: <od4yumygu66vn6hi2ptykbayrqeelqdciwvfrsbmthso7rzbqy@v4ba3bzceluw>
References: <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
 <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
 <537913254.1059.1729273074517@mail.carlthompson.net>
 <od4yumygu66vn6hi2ptykbayrqeelqdciwvfrsbmthso7rzbqy@v4ba3bzceluw>
Subject: Re: Another bcachefs version downgrade bug
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite


> On 2024-10-18 12:12 PM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:

> ...

> It sounds like you should go back to ZFS then.

If you tell me you don't want me testing bcachefs anymore it won't hurt my feelings and I'll respect your wishes. There are plenty of quality filesystems for me to use where I'll have less hassle. But I'd suggest to you that pushing out testers who point out bugs and try to offer constructive criticism isn't the best way to make quality software.

> I have been hearing a lot of people complain about regressions in
> amdgpu. Have you taken that up with them?

I personally have not because other people already have. They're aware of the issues and I'm confident they'll fix them.

> The capability of doing seamless, automatic upgrades and downgrades, to
> the extent that bcachefs can, is something new that other filesystems
> don't have.
> 
> And it's been incredibly useful. Without it, rolling out the disk
> accounting rewrite wouldn't have been possible - and that got us per
> snapshot ID accounting, compression type accounting, per-btree
> accounting, and per-inode fragmentation accounting (not all of these are
> exposed to the user yet, but they're there).
> 
> While bcachefs is still marked experimental, doing these upgrades
> automatically makes sense because it gets us better test coverage of
> codepaths that will need to be rock solid later, and it drastically
> reduces the amount of compat code I have to carry around. I'm hoping to
> get several more on disk format features done while we're still in the
> experimental phase - for inode allocation improvements, fsck performance
> improvements, and assorted other odds and ends.

What you say here makes perfect sense. But I also think it's risky. That's the point I was trying to make.

Carl
