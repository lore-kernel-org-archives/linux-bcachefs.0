Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6BB1E521
	for <linux-bcachefs@vger.kernel.org>; Mon, 26 Aug 2024 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724685535; cv=none; b=tI9vHKf7e5Gadr6Go3zZAX3gxTdK+4dHGRzM8NaI5HjR+P96TOgwXLfkW+K+8nScH2B3rzhb0T49L3l/rcRQjhDOK3nUl9rxbsKfPyD7zFsUBJrAqbZKijwfkNWrOUdWHhS7M1ukkgW40iX4X/Tgp1eTfv0Zu8i6IyJmQ/yvR2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724685535; c=relaxed/simple;
	bh=MS/w52xTMgR5CXsz4soMnd+/LXvjHWWfEpwEXpao5ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=krbSOO7QDlvAl3xGilQ0zvAqM5syv8lPDjqKw/Nen0EBt35ePQUSCO3Qqh9qGcHp6NFKt2KJ4eBwsaJAtogrDhJSjbgtA7KsvuPT79YlbiT9RuiFZ0C+cMXptE6mfOJS+AODeh5SSiaZHiWGHVSAb4Iz36/4KUT6Y7kx3nIwmpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kASoJD0O; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kASoJD0O"
Date: Mon, 26 Aug 2024 11:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724685531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GhNooyecO9dVI2oreJrrE5ExIBN90du5QmNs+nGe3hU=;
	b=kASoJD0OnXcTeCb3qVH423bcMXL9DW7EfyEZ4MbhKXt8J/crw/lXrTZnwkdy0KT2Ak/U25
	SVcM3i8x01Nh4ROAA5yWQJShXVIjFF8MIwfTd78ofxoNJMTFUc/C+EYMlANKAVx7tbR8lk
	kJm4CgtA+Wg6HAayTrlF3EHzHJ0Wub8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christian Brauner <brauner@kernel.org>
Cc: Hongbo Li <lihongbo22@huawei.com>, sforshee@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: support idmap mounts
Message-ID: <jv4fvelrkg4u2znzlmcdwgha7flcetst47ngdjrtbnjybic5jy@p7vvbwtrmlry>
References: <20240824012724.1256722-1-lihongbo22@huawei.com>
 <20240826-mitnichten-zerfallen-f9a348cecb46@brauner>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826-mitnichten-zerfallen-f9a348cecb46@brauner>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 26, 2024 at 12:32:18PM GMT, Christian Brauner wrote:
> On Sat, Aug 24, 2024 at 09:27:24AM GMT, Hongbo Li wrote:
> > We enable idmapped mounts for bcachefs. Here, we just pass down
> > the user_namespace argument from the VFS methods to the relevant
> 
> Fwiw, you're not passing a user namespace, you're passing an idmapping.
> 
> > helpers.
> > 
> > The idmap test in bcachefs is as following:
> 
> I saw that you tested this with xfstests because that has all the
> important testing. Below is just really a "ok, that _looks_ like what
> we'd expect" kind of test.
> 
> > 
> > ```
> > 1. losetup /dev/loop1 bcachefs.img
> > 2. ./bcachefs format /dev/loop1
> > 3. mount -t bcachefs /dev/loop1 /mnt/bcachefs/
> > 4. ./mount-idmapped --map-mount b:0:1000:1 /mnt/bcachefs /mnt/idmapped1/
> > 
> > ll /mnt/bcachefs
> > total 2
> > drwx------. 2 root root    0 Jun 14 14:10 lost+found
> > -rw-r--r--. 1 root root 1945 Jun 14 14:12 profile
> > 
> > ll /mnt/idmapped1/
> > 
> > total 2
> > drwx------. 2 1000 1000    0 Jun 14 14:10 lost+found
> > -rw-r--r--. 1 1000 1000 1945 Jun 14 14:12 profile
> > 
> > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > 
> > ---
> 
> Seems good to me,
> Reviewed-by: Christian Brauner <brauner@kernel.org>

Thanks - queued up for 6.12.
