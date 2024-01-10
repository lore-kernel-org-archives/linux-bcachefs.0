Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B74B5BE
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 21:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id D9EC1140DED25;
	Wed, 10 Jan 2024 13:54:32 -0800 (PST)
Date: Wed, 10 Jan 2024 13:54:32 -0800 (PST)
From: "Carl E. Thompson" <cet@carlthompson.net>
To: Brian Foster <bfoster@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, djwong@kernel.org
Message-ID: <1631784611.745.1704923672726@mail.carlthompson.net>
In-Reply-To: <ZZ13gdxGh8Tn5DdC@bfoster>
References: <20231219140215.300753-1-bfoster@redhat.com>
 <20231219140215.300753-2-bfoster@redhat.com>
 <20231219235742.fmon4qqvbabuxq6c@moria.home.lan>
 <ZZagv/f2lWOSMUSn@bfoster>
 <5sttczrkktgkivq5ncusst3rrjqi7hgpx4nswq2vjqn6iqr4b2@25hi2ukb2rh7>
 <ZZwV5ohFULB2Q2i9@bfoster>
 <1197499938.727.1704753283643@mail.carlthompson.net>
 <ZZ13gdxGh8Tn5DdC@bfoster>
Subject: Re: [PATCH 1/2] bcachefs: add fiemap delalloc extent detection
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

> On 2024-01-09 8:42 AM PST Brian Foster <bfoster@redhat.com> wrote:

> ...

> Ok, but I'm not referring to the pure act of declaring variables
> differently (i.e. such as limiting scope, the other examples given,
> etc.). I'm referring specifically to a policy where all function scope
> variables are uniformly declared at first use rather than at
> top-of-function.

Ahh, I see. I apologize for misunderstanding. In my experience there are definitely cases where declaring some variables at the top of functions makes sense for clarity.

> ...

Carl
