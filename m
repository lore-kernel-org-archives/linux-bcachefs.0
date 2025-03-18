Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14490EACD;
	Tue, 18 Mar 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321453; cv=none; b=BRPu0O/dZ/uicGd6zzApfgFa3NEDYz2epurNwH5knHA33jW6XX90sRnenzYBmz9EEErCaRw4AOQfk55ambpLAPuj0KKzC/Rnh05+g2CeEC+BPW3eJF6QivMPVT3ngqcB5DfkKMqD8XQmKjVgl+DRbuv452b5J86HV3R9bPj1qFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321453; c=relaxed/simple;
	bh=8nDGtCP/XxzTVzfEN/dny6FnMx/4co3il4uooowHvLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbMePlkyGJFqFaeVf6fXJuhDuQeWtnm2lEoyR04qx1rw2VBsg0RwxZz0V6x+E3gQpg+VGfqIRvHy+B3ahHMUZdv5KhKXDNEAw3MXgB/Dsdrdw/AP9aFjwV8687f+7ep7LNUnC+5tuTmmg5We6MHKw7O7vdanCXn/tL6E81BYHG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oY4cGo4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oY4cGo4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABD7C4CEDD;
	Tue, 18 Mar 2025 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742321452;
	bh=8nDGtCP/XxzTVzfEN/dny6FnMx/4co3il4uooowHvLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oY4cGo4tqr69/Vk3MlbBnxmw+KfM8ISFi0o+UoBFd2OEZ36btAqV4OpswEqapcq60
	 nAjqUu2OwXx6eScd+QKOY7rH8o0f/HKawPLuOxF4n6Yi1KDRBSuoREQYOPGUosLdVB
	 YA0RBNY7j8VJFxo7lSGzRTMlKPo8SHxLvVH5osSmAEsCgviQc7V93OgviYZP0AoW5H
	 VDO3idfc/FdTTwRh/DVN+kmmm1mH1xG+e1ZYGnC/bR74OPqnKW331HxGGLBHeShI/C
	 wmvelpYhl6ZE5MlBBGs/ou83JiGthNgKFcs5t/sjLg7zOL3gUWj9JCBxFaLrE+s36h
	 s3FGGeq10U45Q==
Date: Tue, 18 Mar 2025 12:10:49 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9m3KSGxyt_HQ5oD@kbusch-mbp>
References: <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
 <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
 <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
 <18b03fe9-1f57-48ac-92e3-308d27c5d144@acm.org>
 <t4zch7xnj5j3ifnivw3fkhkjpjldk2mozk3ouhogi224ntalab@3jjt2j6crbxe>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t4zch7xnj5j3ifnivw3fkhkjpjldk2mozk3ouhogi224ntalab@3jjt2j6crbxe>

On Tue, Mar 18, 2025 at 02:00:13PM -0400, Kent Overstreet wrote:
> It's certainly not in dispute that read fua is a documented, legitimate
> command, so there's no reason for the block layer to be rejecting it.
> 
> Whether it has exactly the behaviour we want isn't a critical issue that
> has to be determined right now. The starting point for that will be to
> test device behaviour (with some simple performance tests, like I
> mentioned), and anyways it's outside the scope of the block layer.

Maybe just change the commit log. Read FUA has legit uses for persisting
data as described by the specs. No need to introduce contested behavior
to justify this patch, yah?
