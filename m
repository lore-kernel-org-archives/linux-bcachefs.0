Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FCB2582
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 00:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724286935; cv=none; b=VOe5NW3igNlq0jf9T4XCGmJCxRL5mskFatKbTObVO7RJT3zoSzGqphdqYMBD4WnJovhxEOCu3JY1d4ddUjJ+b8xL12XrVfXqchIUlkJHK+S57iPEBBODWwWplnB5SIDjLa6SnxJQpbTw4XYPx/wg/GADz3F2hkTAdF+QcM0WW7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724286935; c=relaxed/simple;
	bh=mlBHYJyx47FkruOvLAPa32m44er7yXdWM51hWwvDO1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQZOkWomVmDeCqJbv8uXqRdUccnCJZFzzQ8ZwxFHpw5lWV3gG7J7oSXHrC92KU1GLkl7QwrzHFx3bxYkuElkCUHvlr+ssx0JqeMtJ72u6BLEc71xh+c5jQqg4ASd8uiNDJ1X9ZjGqZo74D3yJT86MBxobZi72G/sAeUWWYx6b4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bBgqmfFB; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bBgqmfFB"
Date: Wed, 21 Aug 2024 20:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724286929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H92XL9sthO3rg2Z1oUyhWggYiFE6RshyZSdJI9mso/Y=;
	b=bBgqmfFBwnaUQiWFpKflCRWT9jOd8yNwHYKEcmMB4FaqpwKma9MQQEKwNQJZrFdnYBA8Xg
	zlWvh/uOLIrMywif6VhtkyFtwOYiqYCti6k+miACAcu24/gIdpoh7uE0kRzx8uHF9B/QKa
	tZZ7hu7+FJj+BG9ExAoX+hub5Ub8AUo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: brauner@kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: support idmap mounts
Message-ID: <luwoq2ky4m423lohlj442a77nnyocigacbcquwmsbtef4owvow@fim3rtfe2gkn>
References: <20240819015550.2565027-1-lihongbo22@huawei.com>
 <5rkkv6d3w4quqhtnbsevxic7aqoopdguo5goi7unzbkkxutmml@v4d4jjectfgf>
 <686214be-1507-4799-992d-34718f83b92b@huawei.com>
 <hh4xdnbonvxvelcpwruaoke72gqbbt3zotk442bqsb5stez6rh@zhtsgqyyptlr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hh4xdnbonvxvelcpwruaoke72gqbbt3zotk442bqsb5stez6rh@zhtsgqyyptlr>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 18, 2024 at 11:41:14PM GMT, Kent Overstreet wrote:
> On Mon, Aug 19, 2024 at 11:02:14AM GMT, Hongbo Li wrote:
> > 
> > 
> > On 2024/8/19 10:51, Kent Overstreet wrote:
> > > On Mon, Aug 19, 2024 at 09:55:50AM GMT, Hongbo Li wrote:
> > > > We enable idmapped mounts for bcachefs. Here, we just pass down
> > > > the user_namespace argument from the VFS methods to the relevant
> > > > helpers.
> > > > 
> > > > The idmap test in bcachefs is as following:
> > > > 
> > > > ```
> > > > 1. losetup /dev/loop1 bcachefs.img
> > > > 2. ./bcachefs format /dev/loop1
> > > > 3. mount -t bcachefs /dev/loop1 /mnt/bcachefs/
> > > > 4. ./mount-idmapped --map-mount b:0:1000:1 /mnt/bcachefs /mnt/idmapped1/
> > > > 
> > > > ll /mnt/bcachefs
> > > > total 2
> > > > drwx------. 2 root root    0 Jun 14 14:10 lost+found
> > > > -rw-r--r--. 1 root root 1945 Jun 14 14:12 profile
> > > > 
> > > > ll /mnt/idmapped1/
> > > > 
> > > > total 2
> > > > drwx------. 2 1000 1000    0 Jun 14 14:10 lost+found
> > > > -rw-r--r--. 1 1000 1000 1945 Jun 14 14:12 profile
> > > > 
> > > > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > > 
> > > Have you run it through fstests, on the CI? When I threw the last
> > > version in my branch it exploded, as I recall...
> > > 
> > Sorry not run it in the CI, but in my own xfstest(especially for
> > tests/generic/698. I have run the xfstest with 6??, and 698 was passed). Now
> > I have not right to access the bcachefs CI. Could you please help add it to
> > the CI queue when you have some free time?
> 
> hop on IRC...

still waiting on test results for this
