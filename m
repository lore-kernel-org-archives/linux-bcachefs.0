Received: from mail-108-mta14.mxroute.com (mail-108-mta14.mxroute.com [136.175.108.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C740B79CD
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 04:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705465881; cv=none; b=f8WvT8St9mcivi12EQkc2LadIvwbqE0QTaRn0SaXRxdiCCdKDTEauBARcQPLbJ6Egts6yYr5a78xQ6MsDVPYt01RvqJ5TERVtpu5NdrZRnePWxRTPLGDNemo/RziZAVc4NgVtB3y/UMhWEFRM7kbeipJN2b/oWVtBs092zSRAGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705465881; c=relaxed/simple;
	bh=g5XwA68Tzm66tE0CeZSiZUxSDZlh7kdyFhFH44zkMdw=;
	h=Received:X-Zone-Loop:X-Originating-IP:DKIM-Signature:References:
	 User-agent:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type:X-Authenticated-Id; b=iZHXpRq5jqBBbH8sOIc0I4tDF84cGdj773xCxuUZfUYUEPjq4CAwpx483D3MG5aTeOIKpZKIgbHwwrZIIh4UNtSnpTMxQcikMb0A5zg77nLSiKt1JZdyOh3i2qDs6xX0Ye2E0xlmocv34rd0Psw34hhEMtmZ4SkmD3Pep41d2nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=w4lki+Ti; arc=none smtp.client-ip=136.175.108.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="w4lki+Ti"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta14.mxroute.com (ZoneMTA) with ESMTPSA id 18d15ab5ffe0003727.003
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 17 Jan 2024 04:26:09 +0000
X-Zone-Loop: 770d2c344c2453a9966cd0b0fed2cb754be4c2b0afda
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wB2+B/WqHYgJkbDVwVJ3KvTO1gZYQC+mOlnFtIbglgM=; b=w4lki+Ti0Sq6PwvlHoTuVMTha2
	/FkSDMt3f+zHszt2eO5TaaWw9+nIkjgvot3dGZ15oG/HSUxdSDdq0IMPrkwTLPgNL2SRu+O1x6HHX
	CxRJ97T0xFm42fnvnyoOj35RiVxT79J55Xr4ioR5vU7hzg1vrPpB5pWLTqm0xjN9HJvNIjrQ35hQI
	35gF320Y55iB7BAJMgWTIR6tEuV/pggn1ZbQjNNuIcxh2jdQLG4wr1i+uNJxhFqaDbRileXapOybo
	Oqh6c5VxE+Rfj+w4Y7rOTA4/gDX3JUrHXlsd/cWmIi1FyTM21oFMCRtpY6R4Gb7rBuP7JYscLkSll
	wfpqKbRw==;
References: <ZaahtMNCEd42G3EP@bfoster>
 <ze74khldgkvbht5ryjq2bs5rjnm7eds2xytlwc76nqurjwf7tx@rpcyvnwbkglp>
 <Zaa74Ehk4idtZNwc@bfoster>
 <dbqhxiv7kxbaeilxyyqzqqpjlaobxh262u7czkg5koec2w35p4@2oznjzf466no>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] general protection fault, probably for non-canonical
 address 0x280766500040001: 0000 [#1] PREEMPT SMP PTI
Date: Wed, 17 Jan 2024 12:20:55 +0800
In-reply-to: <dbqhxiv7kxbaeilxyyqzqqpjlaobxh262u7czkg5koec2w35p4@2oznjzf466no>
Message-ID: <bk9k60zw.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Tue 16 Jan 2024 at 12:33, Kent Overstreet 
<kent.overstreet@linux.dev> wrote:

> On Tue, Jan 16, 2024 at 12:24:48PM -0500, Brian Foster wrote:
>> On Tue, Jan 16, 2024 at 12:03:09PM -0500, Kent Overstreet 
>> wrote:
>> > On Tue, Jan 16, 2024 at 10:33:08AM -0500, Brian Foster wrote:
>> > > Hi Kent,
>> > >
>> > > JFYI, I'm seeing the following splat pretty reliably via 
>> > > generic/361 on
>> > > an 80xcpu test box. The CI doesn't seem to produce this 
>> > > failure for
>> > > whatever reason. This bisects down to commit 023f9ac9f70f 
>> > > ("bcachefs:
>> > > Delete dio read alignment check"), before which the test 
>> > > still fails but
>> > > the kernel doesn't explode.
>> > >
>> > > Brian
>> > >
>> >
>> > Can you test the following?
>> >
>>
>> Still blows up... repeated a couple times to be sure.
>
> That sounds like a driver bug then - what driver?


I think it's not a drive bug. It's related to bcachefs block_size.
I can reproduce it by running generic/361 with block_size 4096.

The test devices are normal qemu disks backing by files in host.
The bug disappears after hanging mkfs block_size to 512.

--
Su
