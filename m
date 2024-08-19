Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBFC2F4A
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Aug 2024 03:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724038882; cv=none; b=Co5j9TPjW9wd/vwzQgku1nHKNylXdPbi3kG3069yGL9OAn8iv39JjFio1UmW1Djiulnrg3LxceMdS+FU4dZ/LxHt4t6KP7JDykE2C9A0+NtxlVEx2DRCVx1n+dX8lGTdLAEQeWz1e4GZMcDA8P23eRhogU8n13O86rvXgLzaYOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724038882; c=relaxed/simple;
	bh=S/uJrqk0KKJ91oQknXuV/7AWiGvD4auq3OuYZHGc+Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UHPywKx/wAj0WAVbS5kO2I+uOA6QHGiUSXAh+S+c8M0jnztzhEoFH3hrZrqc9Oo5/ouqYIGQ2TaKTOozJIqQI8PuaS+IyXn/ki0NmINITFwwaFwi/gP6QI0mauO545gPNAtnpbudrJQyKLikRCs6QFbbRyD0RGPvmSjOHYJ1tXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X0MYweol; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X0MYweol"
Date: Sun, 18 Aug 2024 23:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724038878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpgjFYZ0Yy+zDv4j3SjRjgOQqstQflhmNcbCWl7s6j0=;
	b=X0MYweolR+BzH1Wy/mCoKF3+W2AGo5kvBqijK4svHnOsBlGFe4kfHpUNmsEhNKB3Jo3hjc
	nzlj+FSzM2ttZquc6MIieX6/i5yDcxWteA8V5Umt3tl7kV7ANPBWZinTmP5X9xYuE/n7Ic
	4+1fU/zDdHzXRVxKcwkJPZHFAjZ4aiY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: brauner@kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: support idmap mounts
Message-ID: <hh4xdnbonvxvelcpwruaoke72gqbbt3zotk442bqsb5stez6rh@zhtsgqyyptlr>
References: <20240819015550.2565027-1-lihongbo22@huawei.com>
 <5rkkv6d3w4quqhtnbsevxic7aqoopdguo5goi7unzbkkxutmml@v4d4jjectfgf>
 <686214be-1507-4799-992d-34718f83b92b@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686214be-1507-4799-992d-34718f83b92b@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 19, 2024 at 11:02:14AM GMT, Hongbo Li wrote:
> 
> 
> On 2024/8/19 10:51, Kent Overstreet wrote:
> > On Mon, Aug 19, 2024 at 09:55:50AM GMT, Hongbo Li wrote:
> > > We enable idmapped mounts for bcachefs. Here, we just pass down
> > > the user_namespace argument from the VFS methods to the relevant
> > > helpers.
> > > 
> > > The idmap test in bcachefs is as following:
> > > 
> > > ```
> > > 1. losetup /dev/loop1 bcachefs.img
> > > 2. ./bcachefs format /dev/loop1
> > > 3. mount -t bcachefs /dev/loop1 /mnt/bcachefs/
> > > 4. ./mount-idmapped --map-mount b:0:1000:1 /mnt/bcachefs /mnt/idmapped1/
> > > 
> > > ll /mnt/bcachefs
> > > total 2
> > > drwx------. 2 root root    0 Jun 14 14:10 lost+found
> > > -rw-r--r--. 1 root root 1945 Jun 14 14:12 profile
> > > 
> > > ll /mnt/idmapped1/
> > > 
> > > total 2
> > > drwx------. 2 1000 1000    0 Jun 14 14:10 lost+found
> > > -rw-r--r--. 1 1000 1000 1945 Jun 14 14:12 profile
> > > 
> > > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > 
> > Have you run it through fstests, on the CI? When I threw the last
> > version in my branch it exploded, as I recall...
> > 
> Sorry not run it in the CI, but in my own xfstest(especially for
> tests/generic/698. I have run the xfstest with 6??, and 698 was passed). Now
> I have not right to access the bcachefs CI. Could you please help add it to
> the CI queue when you have some free time?

hop on IRC...
