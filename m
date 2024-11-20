Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C9D1E4A4
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Nov 2024 23:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732146528; cv=none; b=cDh1faWyXP00xgEmsX8fbPIJYDwwDbTpsm3JpSgA/jnzw5sKtxaRS4mHoqYfh1jXmHueWA+M27HSwwnkm7J9L9xUwWvYT1htyh66ze5YNa5saYizk5U+NsCZLJxYuNDs82KMdJsN84qW2+Sil+jdsVYQa2aPy7PpwPZWLZRLW7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732146528; c=relaxed/simple;
	bh=rAXesqjfUW9M8aDuyil3gDir9rEjTmHztVp5vsEJxTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmF13r7fkUziQVCbbxNQqmcVahp0g3y5zC6R3md/p30iUFRfoSXYXOmZRfobUoeoGgMUhzwQ1N84nJ4iCqsQqTnO3p/aB29Ccy3kLNLsYzA/lGT0QqI1AexHV+KM+sidGAChAF5Xh6ksFwyaxhJ+Y89vu5ASdEjzDVIkjgapBdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=f+lesXKm; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="f+lesXKm"
Received: from macsyma.thunk.org ([50.204.137.16])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 4AKNm0lf023486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 18:48:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1732146485; bh=fIL+3uUquJP7XW30fJ2I0spcbxrpSPj+GzdQTbGjJq0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=f+lesXKmaULfZOT0clMQXq8JXF9H0Xoxpcozw0Y3jPxZpke2jT3LwRlN2seEnZrQ6
	 Q2dnnWl25Q3ch24CF6nB/hWEzCoq9G7JpKBwyxhxg+1YuKuLJm0xPPB2tPoWpMWJfO
	 JLBj+s9/FERKmiJjsyQ6YzmvSdjbzhldjdD2uE3bld88U+FX12v/vHAWfSfOdtxFO1
	 ErdAJsrCDAjvpTVeoS5zfGnl9+r/IvkmU3OUprHGij2TdFBzVWB6giDvzlqPFw+s0h
	 bbCJnO0vc4QUuWi6OLS8FHdMrp12cxuSkb4z7U1s/RQ20OgHHX851GG5q4M6l2ZX7d
	 JpvsjvsSFigng==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id E8A4A3411EA; Wed, 20 Nov 2024 18:47:59 -0500 (EST)
Date: Wed, 20 Nov 2024 15:47:59 -0800
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Michal Hocko <mhocko@suse.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Yafang Shao <laoar.shao@gmail.com>,
        jack@suse.cz, Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-bcachefs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "conduct@kernel.org" <conduct@kernel.org>
Subject: Re: [PATCH 1/2 v2] bcachefs: do not use PF_MEMALLOC_NORECLAIM
Message-ID: <20241120234759.GA3707860@mit.edu>
References: <ZtWH3SkiIEed4NDc@tiehlicka>
 <citv2v6f33hoidq75xd2spaqxf7nl5wbmmzma4wgmrwpoqidhj@k453tmq7vdrk>
 <22a3da3d-6bca-48c6-a36f-382feb999374@linuxfoundation.org>
 <vvulqfvftctokjzy3ookgmx2ja73uuekvby3xcc2quvptudw7e@7qj4gyaw2zfo>
 <71b51954-15ba-4e73-baea-584463d43a5c@linuxfoundation.org>
 <cl6nyxgqccx7xfmrohy56h3k5gnvtdin5azgscrsclkp6c3ko7@hg6wt2zdqkd3>
 <9efc2edf-c6d6-494d-b1bf-64883298150a@linuxfoundation.org>
 <be7f4c32-413e-4154-abe3-8b87047b5faa@linuxfoundation.org>
 <nu6cezr5ilc6vm65l33hrsz5tyjg5yu6n22tteqvx6fewjxqgq@biklf3aqlook>
 <v2ur4jcqvjc4cqdbllij5gh6inlsxp3vmyswyhhjiv6m6nerxq@mrekyulqghv2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v2ur4jcqvjc4cqdbllij5gh6inlsxp3vmyswyhhjiv6m6nerxq@mrekyulqghv2>

On Wed, Nov 20, 2024 at 05:55:03PM -0500, Kent Overstreet wrote:
> Shuah, would you be willing to entertain the notion of modifying your...

Kent, I'd like to gently remind you that Shuah is not speaking in her
personal capacity, but as a representative of the Code of Conduct
Committee[1], as she has noted in her signature.  The Code of Conduct
Committee is appointed by, and reports to, the TAB[2], which is an
elected body composed of kernel developers and maintainers.

[1] https://www.kernel.org/code-of-conduct.html
[2] https://www.kernel.org/doc/html/latest/process/code-of-conduct-interpretation.html

Speaking purely in a personal capacity, and not as a member of the TAB
(although I do serve as vice-chair of that body) I am extremely
grateful of the work of Shuah and her colleages (listed in [1]).  I
believe that their work is important in terms of establishing guard
rails regarding the minimum standards of behavior in our community.

If you look at the git history of the kernel sources, you will see
that a large number of your fellow maintainers assented to this
approach --- for example by providing their Acked-by in commit
1279dbeed36f ("Code of Conduct Interpretation: Add document explaining
how the Code of Conduct is to be interpreted").

Best regards,

						- Ted
