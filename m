Received: from mail-108-mta186.mxroute.com (mail-108-mta186.mxroute.com [136.175.108.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9E5368
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Jan 2024 02:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706149838; cv=none; b=W5aPI1jv7OXdP3+yxeKVAzHeXYPB2r9LvbbTSQX1qT8GgpfHhQ2dgG2o+TrxckrnE4TQvJn8Al3JFwn/WcoDXE/73n9slpFsj/rtrIoTTLNhI+WLQcd6Tut7xG3msxmTPR4G25kVYtXmZYjXpe2TQaWr4kggRhrXs6VhRmSckPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706149838; c=relaxed/simple;
	bh=2AEeLVXZ7AObA+ZDya9xfo4D6zw6kYVmiNEd8XONY/k=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=Ep4tndV+qoR9fdBVsQenN6ApcEw3fobzfvsCDemmAdrEcxY3GULt9Or+ijnWG3xxXVGFXRlaJuyXCbotEgPGe6BbaW3GwUxDozEaaWy2HrEK+Vt8FcNkALj+5K8npJIzhu+CaPYQ3dqnToUKzsqZi48WRiRmPoO51cNU549I/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=G4tbBwTQ; arc=none smtp.client-ip=136.175.108.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="G4tbBwTQ"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta186.mxroute.com (ZoneMTA) with ESMTPSA id 18d3e6fb8b20003727.004
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 25 Jan 2024 02:25:25 +0000
X-Zone-Loop: 04ebc34875262ba5e4f7858e06af1477943ad3678b42
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EVWMPR3ZrMMF6AtNxDTTH7j2bFLpJqGsV+mDPqywWtc=; b=G4tbBwTQfRh6lgP+FFC0domkBq
	hj5ZW2cDtYFfdJPqvAH1VKeGXv0SsYwHTnbFh6pn+w5QKTUMHG3sAWllGjPdbrZtiQ1yp0UxqieAL
	sZms8NLEAtea0jaVqncjWhcj4oG6GEoy5PfSDzYcncZPkOhJezzbmbsaWNgADJ90cbSQMZAStgbh4
	EdMXZMzVXaMeOlPnnA2A8vi0yZ3yvc+qbZyVYBkeqy6tdKSruxUKmT4b1xSdAhL+IVYAImdA8+LDL
	3TWP6PJ+PjsxJ1J3I73HkalJnqS8JVfdQiAEHQ5oc/yY6A4OBZhR/DcmS9jwdS5nh1nI/CBAm9q5a
	Xts+pJMg==;
References: <20240117092309.1134595-1-glass.su@suse.com>
 <20240117092309.1134595-2-glass.su@suse.com> <ZagUdl+DlxIw+siv@bfoster>
 <h6jb49cm.fsf@damenly.org> <ZaqepfRjb1vU+nDw@bfoster>
 <cytv49hm.fsf@damenly.org> <Za6HuxcIl0TNlffY@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <l@damenly.org>, Su Yue <glass.su@suse.com>,
 fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] common/rc: improve block size support for bcachefs
Date: Thu, 25 Jan 2024 10:10:48 +0800
In-reply-to: <Za6HuxcIl0TNlffY@bfoster>
Message-ID: <34umi23g.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Mon 22 Jan 2024 at 10:20, Brian Foster <bfoster@redhat.com> 
wrote:

> On Sun, Jan 21, 2024 at 12:00:47PM +0800, Su Yue wrote:
>>
>> On Fri 19 Jan 2024 at 11:09, Brian Foster <bfoster@redhat.com> 
>> wrote:
>>
>> > On Thu, Jan 18, 2024 at 10:59:14AM +0800, Su Yue wrote:
>> > >
>> > > On Wed 17 Jan 2024 at 12:55, Brian Foster 
>> > > <bfoster@redhat.com>
>> > > wrote:
>> > >
>> > > > On Wed, Jan 17, 2024 at 05:23:09PM +0800, Su Yue wrote:
>> > > > > For bcachefs, def_blksz is never assigned even 
>> > > > > MKFS_OPTIONS > >
>> > > contains
>> > > > > option
>> > > > > '--block_size'. So block size of bcachefs on scratch 
>> > > > > dev is > >
>> > > always
>> > > > > 4096
>> > > > > if _scratch_mkfs_sized is called without second 
>> > > > > parameter.
>> > > > >
>> > > > > Add the pattern to set def_blksz if '--block_size' is 
>> > > > > given > >
>> > > in
>> > > > > MKFS_OPTIONS.
>> > > > >
>> > > > > Signed-off-by: Su Yue <glass.su@suse.com>
>> > > > > ---
>> > > > > changelog:
>> > > > > v2:
>> > > > >     Born.
>> > > > > ---
>> > > > >  common/rc | 3 +++
>> > > > >  1 file changed, 3 insertions(+)
>> > > > >
>> > > > > diff --git a/common/rc b/common/rc
>> > > > > index 31c21d2a8360..6a01de69cf05 100644
>> > > > > --- a/common/rc
>> > > > > +++ b/common/rc
>> > > > > @@ -950,6 +950,9 @@ _scratch_mkfs_sized()
>> > > > >  	jfs)
>> > > > >  		def_blksz=4096
>> > > > >  		;;
>> > > > > +	bcachefs)
>> > > > > +		def_blksz=`echo $MKFS_OPTIONS | sed -rn > >
>> > > 's/.*(--block_size)[
>> > > > > =]?+([0-9]+).*/\2/p'`
>> > > > > +		;;
>> > > >
>> > > > So if the default bcachefs block size is 512b, I wonder 
>> > > > if > this
>> > > should
>> > > > do something like what the udf branch does a few lines 
>> > > > above > and
>> > > >
>> > > mkfs.bcachefs decides block size by querying 
>> > > statbuf.st_blksize or
>> > > BLKPBSZGET from the device if the option is not given.
>> > >
>> > > > override the hardcoded default of 4k. ISTM this whole 
>> > > > thing >
>> > > would be
>> > > > more robust if it just elided the param in the default 
>> > > > cases > and
>> > > let the
>> > > > associated mkfs tool use its own default, but that's 
>> > > > probably > a
>> > > separate
>> > > > issue. Hm?
>> > > >
>> > > Since there is no default block size of bcachefs, maybe we 
>> > > can let
>> > > mkfs.bcachefs decide on its own but it will make chaos when 
>> > > somebody
>> > > reports an unreproducible BUG due to the different 
>> > > block_size even
>> > > we have same local.config. It just happened...
>> > > So for now, I think 4096 is a resonable value of bcachefs 
>> > > block
>> > > size.
>> > >
>> >
>> > I think we run into this no matter what if we pick a size out 
>> > of a hat,
>> > regardless of what the value is. If somebody is testing with 
>> > default
>> > blocksize (i.e. based on mkfs) on a filesystem where the 
>> > default isn't
>> > actually 4k, then it seems quite unexpected that 
>> > _scratch_mkfs_sized
>> > would use something different from _scratch_mkfs when a block 
>> > size isn't
>> > explicitly specified. That's exactly the situation we ran 
>> > into with the
>> > generic/361 thing where I would have expected this test to 
>> > use 512b
>> > blocks.
>> >
>> > ISTM that the 4k value in _scratch_mkfs_sized() is mainly a 
>> > last resort
>> > default value so the $blocks calculation can work for any 
>> > filesystem
>> > that might not be properly supported by the function. The 
>> > function looks
>> > a little wonky overall, but I think there are at least a 
>> > couple options
>> > to improve things for bcachefs. FWIW, it also looks to me 
>> > that nothing
>> > actually passes a blocksize param to _scratch_mkfs_sized, so 
>> > perhaps we
>> > could just drop that blocksize=$2 parameter across the board 
>> > as a
>> > simplification?
>> >
>> Maybe it can be dropped. The only user is generic/466
>>
>
> Ah, good point.
>
Sorry for the late reply, was busy with other works.

> So generic/466 clears MKFS_OPTIONS so the function will use the 
> provided
> block size over whatever exists in the config, yet generic/466 
> is the
> only user of this param in the first place.
>
> I wonder if a more useful change might be to change the
> _scratch_mkfs_sized logic to prefer the provided block size over
> whatever is in the config, but then again that might require 
> further
> changes for any of the places that continue to use MKFS_OPTIONS. 
> :/
>
I am wondering too...

>> > With that, I think bcache could either:
>> >
>> > 1. Do something like def_blksize=`blockdev --getpbsz 
>> > $SCRATCH_DEV` in
>> > the first switch if no block size is specified in 
>> > MKFS_OPTIONS (or
>> > whatever best mimics mkfs logic).
>> >
>> > OR
>> >
>> > 2. Do something like the following in the last switch:
>> >
>> > 	[ -n $def_blksize ] && 
>> > def_blksize="--block_size=$def_blksize"
>> > 	$MKFS_BCACHEFS_PROG ... $def_blksize $SCRATCH_DEV
>> >
>> > ... to allow mkfs to determine the block size. I _think_ that 
>> > works
>> > because the bcachefs format doesn't depend on $blocks at all, 
>> > so
>> > whatever $blocksize was set to is irrelevent unless 
>> > $def_blksize was set
>> > above, but I could be missing something. That also assumes 
>> > blocksize
>> > wasn't set to something by the caller.
>> >
>> > If correct, option #2 seems a little cleaner to me, but other
>> > thoughts/ideas?
>> >
>> Option 2 is preferable. I would code it as(on more varaiable 
>> for
>> readability):
>>
>> local blocksize_opt
>>
>> [ -n $def_blksize ] && blockzie_opt="--block_size=$def_blksize"
>> $MKFS_BCACHEFS_PROG ... $blocksize_opt $SCRATCH_DEV
>>
>
> That seems reasonable to me. The only caveat is this was 
> assuming the
> blocksize param would go away and so could be ignored for 
> bcachefs.
>
> Without getting too far into the weeds on the higher level 
> parameter
> handling, I wonder if the blocksize parameter was initially put 
> into a
> separate variable (i.e. blocksize_param or some such), if that 
> would at
> least help bcachefs determine between the case where 4096 was 
> requested
> by the caller vs. picked out of a hat by the default handling 
> logic
> earlier in the function, and thus correctly determine when to 
> set a
> blocksize vs. use the mkfs (non-4k) default.
>
After going through the call stack of _scratch_mkfs quickly, I did 
not
found something global to describe blocksize.
So I think blocksize_param is unnecessary?

--
Su

> So then IOW the logic might look something like this..?
>
> 	[ -n $blocksize_param ] && 
> blocksize_opt="--block_size=$blocksize_param"
> 	[ -n $def_blksize ] && 
> blocksize_opt="--block_size=$def_blksize"
> 	mkfs ...
>
> Brian
>
>> --
>> Su
>> >
>> > Brian
>> >
>> > > --
>> > > Su
>> > > >
>> > > > Brian
>> > > >
>> > > > >  	esac
>> > > > >
>> > > > >  	[ -n "$def_blksz" ] && blocksize=$def_blksz
>> > > > > --
>> > > > > 2.43.0
>> > > > >
>> > >
>>
