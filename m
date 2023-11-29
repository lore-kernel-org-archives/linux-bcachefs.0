Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gr8hmQyi"
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB04A8
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 13:43:36 -0800 (PST)
Date: Wed, 29 Nov 2023 16:43:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701294213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6GTs/Bvk4u6125pXeIB7YBqDHWbeYlhoerZiW+ag1QI=;
	b=Gr8hmQyiOb4Fs0/dAIgeaUuMZYAKuRBCRVAyw9ORfZgSIAKD6mc8RPIuYXwjXMw1PkIrM+
	OSSoFFVT1CS5oY2uDngc75n4yPEqqn8zP/oXOSS1iPT5V6809EClkVbEisjYhVyKVrQSdk
	V56DnNujpW3j9yY6+FNOz2PF50933To=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Donald Buczek <buczek@molgen.mpg.de>
Cc: linux-bcachefs@vger.kernel.org,
	Stefan Krueger <stefan.krueger@aei.mpg.de>,
	Neil Brown <neilb@suse.de>
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Message-ID: <20231129214328.efbfpl3javifvwk5@moria.home.lan>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 08:49:23AM +0100, Donald Buczek wrote:
> Hi,
> 
> I'm happy, bcachefs finally made it to mainline, Kudos to Kent!
> 
> As far as I know, there is an ongoing discussion about the problems of non-unique inode numbers exposed by snapshots an no real conclusion yet, on how filesystems should expose snapshots.
> 
> The current behavior is kind of a showstopper for us, because we are still running multi-user systems. The problem is, that any unprivileged user can create subvolumes and snapshots:
> 
>     buczek@dose:/scratch/local3$ bcachefs subvolume create vol1
>     buczek@dose:/scratch/local3$ mkdir vol1/dir1
>     buczek@dose:/scratch/local3$ bcachefs subvolume snapshot vol1/snp1
>     buczek@dose:/scratch/local3$ ls -li vol1/
>     total 0
>     1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
>     1476413180 drwxrwxr-x 3 buczek buczek 0 Nov 20 15:01 snp1
>     buczek@dose:/scratch/local3$ ls -li vol1/snp1/
>     total 0
>     1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
>     buczek@dose:/scratch/local3$ find .
>     .
>     ./vol1
>     find: File system loop detected; ‘./vol1/snp1’ is part of the same file system loop as ‘./vol1’.
>     ./vol1/dir1
>     buczek@dose:/scratch/local3$
> 
> We have a few tools which walk over the filesystem (backup, mirror, accounting) and these are just not prepared for non-unique inode numbers aside from regular hardlinks. I'm concerned that experiments of a unprivileged users could make important tools to fail.
> 
> Questions:
> 
> - Would it be a workaround to make creation of subvolumes and snapshots privileged operations?
> 
> - If we want to evolve our tools: What is the best way for userspace to recognize subvolumes and snapshots and tell them apart from ordinary directories?

I'm considering writing an "integer identifiers considered harmful"
paper. I haven't dug into it yet - just skimmed the lwn coverage - but
adding in the overlayfs issue makes this problem sound fundamentally
unsolvable given the current constraints.

Recognizing subvolume boundaries: we don't have anything for this yet,
and given what happened with btrfs I'm not sure we want to go that
route.

We could (probably) expose unique inode numbers, filesystem wide, but at
a cost. We'd have to restrict ourselves internally to 32 bit inode
numbers, and then report inode numbers that include the subvolume ID as
the high 32 bits.

That won't leave enough bits to shard inode numbers at create time based
on CPU id, which isn't the _most_ important optimization, but would hurt
to lose.

Going forward, we really need - as you allude to - better userspace
APIs. Inode number probably can't be an integer anymore, it needs to be
a string if it's going to be able to do all the things we want it to do.
