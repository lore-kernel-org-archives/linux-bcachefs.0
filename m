Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27E32BCF5
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 01:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752890132; cv=none; b=u3yNoDbomf5ucu5WX7s3dirMF7raSIKBeK3ck2qvi/yfSdDytZ7UC5WMlQxsH9bZ2gYtFQBkjzmttR0FRl5FnbypSe3GJgvLPZUMBhPjnHpfNWPYPJfE/vQGCfEmvtG6kRMCR1eTUTYvJLuDmr4Xtv2r1La7kG7ZdDdZkOyQfyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752890132; c=relaxed/simple;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1fXaJ4o7tZ7aM30J5Dx0gkGZljWpimdRbjwyOh8//SeGgIDBRSoTa3CmEGXchW0KZM8Q28K/2acCWgQwWvjUSrdC88JzaXLKzqDL8oBRHjbw1gMFuiwneDX4R1fhxMoTN3OIR+wBMd+j9JLoO1ygxK8KJy9zPBmuJ06L2dtPog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qiYlvQuH; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qiYlvQuH"
Date: Fri, 18 Jul 2025 21:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752890127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	b=qiYlvQuHqEjkt6dphfFYuZTPK2j0rNfs5bOsrxuy+/h88+w6vqOS/cj7aimvJSXnat0R73
	mrf4kHi+w7IFYMgF/PhDzM5lqtiVuQhCGdYHusM/nUgiKLOrXV9zyJXli6UBTq6FIoxdAu
	AqYZPywkKYLfquSaQ+THMkja9LD//Wo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+3ba6dd3d414ec2296f3c@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_node_iter_init (2)
Message-ID: <65qmqj62ehtkqesre7anmexy7srvnoq2yw5vuk6cmgll3uulcc@hu5icnfydn5j>
References: <686ea916.050a0220.385921.0013.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686ea916.050a0220.385921.0013.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Don't build aux search tree when still repairing node
