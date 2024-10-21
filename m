Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A331E0DDD
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 07:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729496634; cv=none; b=cXrLWITyIhJ4DHPWxDpIFK27GzaFifnymRziOrOXMNWFHQ08Ek2TlVSl2ADy7eNl1toSV21KKyIfEqQTomLPLRPwk4HME/pRBWNlS73TmK/ckQSjaJY78ipoq2QfeOl2M2avpBzEjzqY6u6cvfu/lbQY6ADpvFEeU70aGLTZuYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729496634; c=relaxed/simple;
	bh=f3Yxbbp23UC7gkyGEQQQHiffhrRJ/Ik+ccyzNHmpGwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHINCbvQzYHPLwyfduwHCEUVBLPRNUFUx08zNA6gmJGpXoPsf9p/LNwUjeJDKkJecsTBmVbrtwiTIAUZPO7lgxyxGOUO4bQj5n91yPrFhMay/ROq8ZMqhvB5sP3I0dkOPdA8EueJc1/yCfUmFwn9WAumWf/O/3K+Aw027g0IFvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 829397CCBC;
	Mon, 21 Oct 2024 07:43:47 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christopher Snowhill <chris@kode54.net>,
 "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject:
 Mounting multiple versions/snapshots/images at the same time (was: Re:
 Another bcachefs version downgrade bug)
Date: Mon, 21 Oct 2024 09:43:47 +0200
Message-ID: <8442433.T7Z3S40VBb@lichtvoll.de>
In-Reply-To: <nvs2h7qmf3fsffrnh4rus7hhdkxh7fjfjnzfv7rgqrb43udzyj@lutkh4gkoiya>
References:
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <216190573.1599.1729470893479@mail.carlthompson.net>
 <nvs2h7qmf3fsffrnh4rus7hhdkxh7fjfjnzfv7rgqrb43udzyj@lutkh4gkoiya>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi Carl and Kent,

It is a topic change, so please ping if you like to be dropped from CC.

Thanks for the constructive discussion here. I pick out an aspect I am 
quite interested in.

I am extending this aspect to mounting different snapshots at the same time 
in case you, Carl, did not mean this.

Kent Overstreet - 21.10.24, 03:15:47 MESZ:
> I'll give you an example. More than a year ago I raised the issue that
> 
> > bcachefs does not allow multiple versions/images of a filesystem to be
> > mounted at the same time. I pointed out that there are several
> > professional workflows that require this (forensics, auditing, etc)
> > and non-professional workflows too (retrieving a previous version of a
> > file from an LVM snapshot, etc). I pointed out that other modern
> > filesystems allow it and argued that it is a needed feature. You
> > disagreed that it is that important and have never (to date)
> > implemented the feature. This causes me to have to create special-case
> > workarounds specific to bcachefs which operate differently than what I
> > do for every other filesystem. Despite this extra work and
> > inconvenience for me I have never brought it up again, never nagged
> > you and never demanded that you listen to me and change your mind. I
> > made my pitch, you made your decision and I accept your decision even
> > if I don't like it.
> 
> If I came across as strongly disagreeing on that issue, I apologize.
> 
> On that issue, it's just that it's a really problematic feature for a
> multi device filesystem - we have to have a unique identifier for
> identifying the filesystem, separate from the block device, and if it's
> not actually unique - what do we do?

There are several different variants of this and I bet it is important to 
clarify exactly what is meant here. At least these two come to my mind:

1) Mount a block-for-block clone of the same filesystem another time.

2) Mount a snapshot of one filesystem on one block device to a different 
location in filesystem tree.

Carl, what is the one refering to? If you mean a third thing, please 
elaborate.

I do the second one with BTRFS in combination with the default subvolume 
feature in order to hide away snapshots.

First I create a subvolume where I can create snaphots and one for the 
actual filesystem contents. Then I tell the filesystem to use the snapshot 
for the filesystem contents as default for mounting. And then I additional 
mount the subvolume that contains the snapshots to a different location. 
Something like this:

/dev/nvme/system / btrfs lazytime,compress=zstd,discard=async   0       0

/dev/nvme/system /snap/system  btrfs   subvol=snap   0       0

(in this case BCacheFS on LVM as I wanted to have the flexibility to test 
out different filesystems)

This makes it easy for me to exclude all snapshots from backup operations 
as I can do top level snapshots of the filesystem contents and "hide" them 
away in a subvolume (means sub directory in filesystem tree) of my choice.

I still use rsync for backups as it has stood the test of time. I could 
probably switch to BTRFS send/recieve or a similar functionality in 
BCacheFS. With the added benefit of way better handling of renames.

> Even for single device filesystems it's a problem, because some of our
> userspace interfaces use that same unique identifier (sysfs, debugfs)
> and a single device filesystem can become a multidevice filesystem at
> any time.

I am not sure whether case 2 would already be possible with BCacheFS. If 
not, this would hold me back from switching over completely. Of course I 
can try to rework my setup, but I'd prefer not to. Unless someone can 
convince me of a good technical reason to do it.

> So it's not impossible, but genuinely messy, and it's the kind of thing
> I could see leading to landmines later, which makes me not particularly
> eager to touch it. But if it keeps coming up, I may end up giving it
> more study in the future.

Well it would be important to find a somewhat clean approach about that. 
I'd rather not have a feature than a feature that could be unreliable due 
to it being messy.

I do not know how other filesystems do either 1 or 2 of the above variants. 
All I can say is that with variant 2 on BTRFS I did not see an issue so 
far.

Best,
-- 
Martin


