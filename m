Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDCDC2EA
	for <linux-bcachefs@vger.kernel.org>; Sat, 27 Dec 2025 00:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766794093; cv=none; b=QBPGl2D72zLCH8/I/SaHWRHtL6zOmqcpqMtJYChNlgkrtEld1xjjFirePsXuZCjLXAeljmdubbTcgdPKiUyimV8cx10m1lCypfoIZMe2qAHvFgTMVsUkxw1qcKLeMVjTuRosIb8mqVSW+mrqqUP8mfYGliCp6YPE8eDWcVQX6LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766794093; c=relaxed/simple;
	bh=zvCs66as6LFhYflo3HpF49jyr79qQI/i3hQLRsyLtbU=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=IjJGyLIKDBV3R9fKFHlm87G9HuJX+RdUs2BEPWWBysy3rT1Na1hHfDaWHdOLr7yD9vu8ctjFMva/tOOGwpoCLlB7aiePDOfEuj+ro7wHbfIf4EfWLHHWGr88l5+kJKxFnfaRDqFQaN+QAJLYRuW+Bl38FQO2U88gw6jpAO1rqmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=WkwOp+EA; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="WkwOp+EA"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 3EAE5240027
	for <linux-bcachefs@vger.kernel.org>; Sat, 27 Dec 2025 01:08:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1766794083; bh=8Xtss41OmosZ4qLIqEJiJxnomcUAFYSY0wOvBlRnyQo=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Transfer-Encoding:From;
	b=WkwOp+EAzFotuGdSfjFcviyt5x2hvljD30GSl6iNCVslP+RV/1Jlrogmi7jR49BHh
	 sdrTJUQePaw6QpbGiZyJX+QKLwVyoz4DNscdh5ozLM+IJxR4vnNXJwoWJVoWTxRfwr
	 NP+Azp3luZBTRqwaVDvDoWWgpUJB3wYoUnlmYap1gGUXSfQK9FC+ic8vbem1pLNz3h
	 kFa4PwTWI8D+IDBIZZBCUCP6uoBYPZDQJEJWu6EKPXFUnz/Hm9AvsWm3vH54Z3hFjQ
	 XdY0PQtpEg4poTng51J1LBis30+I08Z+MQJ+nDKx+qbyb2HzJetIX9rDz48TjoD5Ba
	 S2HIko3mrUJsA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ddN9G6rHCz9rxF;
	Sat, 27 Dec 2025 01:08:02 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 27 Dec 2025 00:08:03 +0000
From: BP25 <bp25@posteo.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Version Control capabilities plus two small unrelated questions
In-Reply-To: <7dgvgc3usnl4nbpivj3wuemprknevx5tudji4ldzqkq7ngvfva@sbdg5tfhjnll>
References: <f284018630d0a24414d38028cd397345@posteo.net>
 <7dgvgc3usnl4nbpivj3wuemprknevx5tudji4ldzqkq7ngvfva@sbdg5tfhjnll>
Message-ID: <e5a602de45722f9f8fe85f24b93e8d21@posteo.net>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

Dear Kent,
Such an honour to receive your reply! For the sake of simplicity assume 
that I'm just interested in snapshotting individual files. Usecase: 
because I add the snapshot command as hook before saving any file I 
edit. This assumption excludes any discussion about recursive snapshots.

On 26.12.2025 18:09, Kent Overstreet wrote:
> On Wed, Dec 24, 2025 at 04:02:01PM +0000, BP25 wrote:
>> Hello, would someone kindly advise whether bcachefs supports file
>> versioning, somewhat in the spirit of Stallman (lecture at KTH Sweden 
>> in
>> 1986) where files are individually versioned (as opposed as taking 
>> snapshots
>> of entire volumes) but the versions are not just ordinary distinct 
>> files,
>> they are hidden files connected with each other.
> 
> Got a link to the lecture?

https://www.gnu.org/philosophy/stallman-kth.en.html starting from 
"Features that I believe must be added include: Version numbers" until 
"Another thing, that isn't a user visible feature and is certainly 
compatible to put in, is failsafeness in the file system."

>> In particular is there a standard way to 'follow' the same file along 
>> its
>> snapshotted versions? Say, ask bcachefs to return the list of 
>> snapshotted
>> versions by giving input this or that file in the current version of 
>> the
>> filesystem? Note that if such file was deleted and another with the 
>> same
>> name created I don't want that new file also to show up. And related
>> question, is there any command that would list the snapshotted files 
>> which
>> have no corresponding in the current version of the file system (for 
>> example
>> because I deleted such file after having snapshotted it)?
> 
> Snapshotting is only at subvolume granularity, and right now there's no
> way to create a subvolume that points to a single file. There's no
> reason that couldn't be added, but if you do that you'll probably still
> want to be able to follow history at the outer subvolume level; we 
> don't
> have proper support for recursive subvolumes.

Rather than having to promote files to subvolumes and then snapshotting 
them, I'd rather allow making snapshots any individual file directly. 
Just because any file should be ready by default to be versioned. 
Sometimes I do wanna follow history at the outer subvolume level; but 
most times I wanna focus on the timeline of this specific file and even 
if snapshotting the outer volume achieves this in practical terms, 
conceptually I would say the two procedures serve distinct purposes.

> History between different subvolumes is completely distinct; I could 
> see
> us wanting to support some sort of concept of "nested histories", but
> that'd be a project for down the road.

I think that in view of the assumption at the beginning of this email, 
we can disregard for the moment any notion of nestedness and of shared 
histories.
> 
>> First small unrelated question: do you confirm that standard Guix is
>> currently incompatible with bcachefs as root filesystem and is there 
>> any
>> plan to patch Guix so that it's possible (with standard Guix 
>> installation)?
>> Note: "Currently Guix System only supports ext4, btrfs, JFS, F2FS, and 
>> XFS
>> file systems. In particular, code that reads file system UUIDs and 
>> labels
>> only works for these file system types."
> 
> I haven't seen any incompatibilities reported. Util-linux supports
> bcachefs and has for ages, so I'm not sure what that would be.

I asked this on the Guix mailing list. My understanding of your sentence 
is that you're not aware of any difficult obstruction to make it work.

> 
>> Why does the generation number in bcachefs snapshots starts from 
>> U32max and
>> goes down, instead of the naive start from 0 and goes up? There must 
>> be some
>> strong conceptual reason for doing the first because I see already a 
>> few
>> small conceptual reasons to do the second.
> 
> It's because of the way snapshot lookups work. When we do a lookup
> within a subvolume, we first get the subvolume's current snapshot ID,
> and then we do a lookup for SPOS(inode, offset, snapshot).
> 
> We want either the key for snapshot, or the closest descendent;
> allocating snapshot IDs in reverse order means that ancestors come 
> after
> our search key, not before, and this is important because iterating
> forwards is much cheaper than iterating backwards.

Thanks for explaining this.

I appreciate you reading my messages Kent.
