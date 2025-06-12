Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B0223185C
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735931; cv=none; b=enCNAjpwtBAWd1IsH8o5Zvn60rEL4st8mE9HATCZ0mtK9QWoVsYpwYp0QR1SQKOKznwMeR+BmcOphBma2c717us4Ikr3s0tdzrGQGYYYM0+5MbwSljpyEDaU+zKi1CqrVK1hlWYZtGpVvHQjPeMBLyR8D4f+zODhFVzZSAgUV5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735931; c=relaxed/simple;
	bh=ASKEXii7nOIcSLXg1NEhjxHQqGbyFbYZyoavQddQ6UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myiYkHaW5I67mxdfG+c2KxmEb23o47c5XFPlbymHoH98zcVE09JU6Uc5mnhzLGevP8SJQBBoy7fDszqRJbb+bVZwpfMGL/V6dLf0jke6kZ9jqzMkYySiY7seYgSVcCG1RgZR9bUouAUBaNhn9q2JB2YsrjXY0/ZL8ubYd6n2OiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SVMGhFN/; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SVMGhFN/"
Date: Thu, 12 Jun 2025 09:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749735926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJdJBta/Xh1lo6+CNetDj3jrjlMZBbkhjhztZT0nUo4=;
	b=SVMGhFN/k/7Z7Pf3r/mAb1GYr2LDuP+7LScRtNMraQQBYoxQfZ2eTbLh7Vbow+3XljaqwL
	ZtH+anif8XbDxgA9n+j5u8EQphhgnXyP78hiJPzEobef1mX6O9VxclyGGt9JIeVrnX5cxi
	NEkN52bYhf5E2/5ylMnhWFsShtN5LD8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org, Hongbo Li <lihongbo22@huawei.com>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Message-ID: <5etvxpcqguoxh6trjsvxk2pfjap5otsj5kf7ioz67fznhlgzi6@vav7ef3xpyww>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
 <2229760.irdbgypaU6@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2229760.irdbgypaU6@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 12, 2025 at 03:04:37PM +0200, Martin Steigerwald wrote:
> Kent Overstreet - 31.05.25, 01:16:04 CEST:
> > > I have a directory entry that according to ls -l is quite big:
> > > 
> > > drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
> > 
> > Yes, this is due to a leftover from the directory i_size patchset that
> > had to be reverted. As long as it's not causing issues it'll be a bit
> > before I get to it, I've got higher priority bugs I'm working on right
> > now (as usual).
> 
> On 6.15.2. How can I trigger repair code from commit
> 
> bcachefs: Repair code for directory i_size
> 
> 66c36452163871360f15dc4042dd00612e42cd66
> 
> ?
> 
> Currently still has that odd size.
> 
> I tried "bcachefs fsck -k" so far, but so far only while filesystem is 
> mounted, as after I dismount it I get back the device node from LVM would 
> be busy. But I see no indication as to why.
> 
> If fsck in dismounted state would do the trick I can try disabling 
> automatic mount on boot.
> 
> Again no priority. I do not use SSHFS on that filesystem.
> 
> I suppose I could just create a new directory and move over the files from 
> the one with the odd size.
> 
> However, keeping as is for now. Maybe I can help testing repair code. :)

Well, I do need to work on making the rest of the fsck passes work
online, maybe I'll be able to start on that soon... fingers crossed :)
