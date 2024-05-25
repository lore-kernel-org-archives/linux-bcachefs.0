Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC381127B5F
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 May 2024 20:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716670015; cv=none; b=SiijUWpO7wL4EI/pWYR9wc4AjRhaeEbsFxNsHXrwZJyjRuIzluJ1RfWKKCXn2HfrR0dOrUjNtFDpaJV1npO+Kz4zQjGQ/kMc+20+0QAejvyefzu5pfiK6UAP3ps8lk0EAQu+KMHHPo/SvG1R0wVFxaYFvQKxru4mqxc3tctPb68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716670015; c=relaxed/simple;
	bh=Gzjzi/NNX2TCL/9wh9DGiJ+HuPokd4Eg0e9hywr+1JY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8CjNdRmBi3wqxzVU/t+LbaTU3J+OLu7qnPHJHOZZn52pqT1IzWdZAIIkGvs92ebbE5IgWuIb9L/iofUo0EYdxH5ESgUj3uKErTeTD8ibVw9jZoDkq94ctbcLn8ShB81N7QRkHBwrMyBi5uLGRzWKrHMXkMtqSXnomx0d/m0FJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ja2XokmS; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ja2XokmS"
X-Envelope-To: tahbertschinger@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716670010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eOptNKI7RYVgbZu0ZgCL60XuGE/UJDJ8g4q3Oz6B2G4=;
	b=ja2XokmSEGvvrKEJp7wn3ISxY9/IqEdPD+oPHH+V7MGblJPMhmCSiA1AsWZ8Sa868MUF1h
	jGRZQvOrcwljwv+z0oXS/ahOTHEqk95EztnH9rv+ApOemATEFH/L09u4UJMgL9gHWN7oL1
	Gt0zycnEiYcHkfDRuHSlE0z/H9jP5nE=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: bfoster@redhat.com
Date: Sat, 25 May 2024 16:46:45 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] bcachefs: allow passing full device path for target
 options
Message-ID: <2re33povuucemthvk2yl6243zqnevfgd4kdoqgzxwgzitftork@axtd32kppam7>
References: <20240525193619.401336-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240525193619.401336-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, May 25, 2024 at 01:36:19PM -0600, Thomas Bertschinger wrote:
> The output of mount options such as "metadata_target" in `/proc/mounts`
> uses the full path to the device.
> 
> mount(8) from util-linux uses the output from `/proc/mounts` to pass
> existing mount options when performing a remount, so bcachefs should
> accept as input the same form that it prints as output.
> 
> Without this change:
> 
> $ mount -t bcachefs -o metadata_target=vdb /dev/vdb /mnt
> $ strace mount -o remount /mnt
> ...
> fsconfig(4, FSCONFIG_SET_STRING, "metadata_target", "/dev/vdb", 0) = -1 EINVAL (Invalid argument)
> ...
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Applied
