Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC182209B
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 20:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729541733; cv=none; b=FlcHFITz8s1ODCwm1rEOK74MujTD4+31ODx+K0tYNpJgQO6AxadBumgA5coqzMiYbI9QjqTgInVH6J5E0mYeezVwy+HWuFANLR/m+J/VKvRMkhlzWkDbUeAL392jkiFLTtwk+UnEzl7scbjT3mI8Kktd5P+H4LDA1ftzhQxp4mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729541733; c=relaxed/simple;
	bh=4Pxu8DLN/NX72hV+GUxSsKxBEbcPzwDCnX6km0O9d+s=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=RdJ364oKahV8y00mhoyB3EwFxCb+rvN9zlZjqb5MbHO8Jw+AeFeDHJWrmqTcMW6UP4KoP2NTiM2lBkuK1jMY8Qr7GljPPKi0gp1Bb865cWGtODQpZrzdsIQSxQNAVUi4U/kGzX0Q+BtzPg3fd3wo0Sd7oCcwNvGdvNfL30jMhvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id A9B81601C369F;
	Mon, 21 Oct 2024 13:15:29 -0700 (PDT)
Date: Mon, 21 Oct 2024 13:15:29 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Martin Steigerwald <martin@lichtvoll.de>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christopher Snowhill <chris@kode54.net>,
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <1376911148.1751.1729541729512@mail.carlthompson.net>
In-Reply-To: <8442433.T7Z3S40VBb@lichtvoll.de>
References: <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <216190573.1599.1729470893479@mail.carlthompson.net>
 <nvs2h7qmf3fsffrnh4rus7hhdkxh7fjfjnzfv7rgqrb43udzyj@lutkh4gkoiya>
 <8442433.T7Z3S40VBb@lichtvoll.de>
Subject: Re: Mounting multiple versions/snapshots/images at the same time
 (was: Re: Another bcachefs version downgrade bug)
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


> On 2024-10-21 12:43 AM PDT Martin Steigerwald <martin@lichtvoll.de> wrote:

> ...

> There are several different variants of this and I bet it is important to 
> clarify exactly what is meant here. At least these two come to my mind:
> 
> 1) Mount a block-for-block clone of the same filesystem another time.
> 
> 2) Mount a snapshot of one filesystem on one block device to a different 
> location in filesystem tree.
> 
> Carl, what is the one refering to? If you mean a third thing, please 
> elaborate.

I am talking about both 2) and 1). However, I'm talking about thin **LVM** snapshots, not bcachefs' native snapshots. I'm also talking about file images of entire filesystems (what you'd get if you ran something like "cat /dev/nvme0n1p1 > /fs.bak"). 

I have several computers on which I use several different filesystems, and on almost all of those computers I use (thin) LVM. Since I'm using LVM anyway it's easier, more reliable and more consistent for me to use LVM's snapshots rather than the filesystems' native snapshots (if any). For similar reasons I also tend to use MDRAID instead of the filesystems' native multiple device support and LUKS instead of the filesystems' native encryption support. I'm also thinking about adding checksums to every filesystem using dm-integrity but I haven't gotten around to planning that out yet. So if I need to build server that absolutely needs to run reliably and consistently my current default is:

  Drives -> MDRAID -> LUKS -> Thin LVM -> XFS

I know that's really old-school and really un-sexy these days but it's essentially bulletproof when managed properly.

> ...

> (in this case BCacheFS on LVM as I wanted to have the flexibility to test 
> out different filesystems)
> 
> This makes it easy for me to exclude all snapshots from backup operations 
> as I can do top level snapshots of the filesystem contents and "hide" them 
> away in a subvolume (means sub directory in filesystem tree) of my choice.

I'm not sure I understand what you mean but I don't think I do it that way.

> I still use rsync for backups as it has stood the test of time.

Yeah, I've fought with rsync for a couple of decades now and it's the transport used by my backup system. For me rsync has always been problematic. It semi-regularly hangs despite being run on completely quiescent snapshots, it has atrocious performance on large images and it has some security weak spots that probably don't matter much on a secure network but still bother me. So I'm going to switch out rsync for BorgBackup at some point which should allow me to scrap most of my current backup system except for the front-end. If you've ever had any issues with rsync you might want to check it out. There are actually a bunch of other newer alternatives to rsync I've tested but for me BorgBackup was the winner.

> I could probably switch to BTRFS send/recieve or a similar functionality 
> in BCacheFS. With the added benefit of way better handling of renames.

There are actually projects that you can find on GitHub and elsewhere that allow you to do the same sort of send/receive that xfs/zfs/btrfs can do on **any** filesystem by working at the thin LVM level. (The tools require that you are using **thin** LVs which you should be anyway.) I use this method when I need to send an efficient, incremental **exact** copy backup of an **entire** filesystem somewhere else.

These tools are nice because they don't require reading or sending every block on the source device just the changed ones so they're efficient which is crucial for large filesystems or slow networks. I use this technique instead of the native filesystem send/receive so I can use can have a consistent interface across any filesystem. I won't point you at any particular project as what I'm using has been heavily modified for my particular use case.

> ...

Thanks,
Carl
