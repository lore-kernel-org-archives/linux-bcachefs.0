Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CB01DA23
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 Nov 2023 21:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB3B30EA
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 Nov 2023 13:19:44 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-260-9X0Ntu3lPqyJDUuLsEyWOg-1; Sat, 11 Nov 2023 21:19:41 +0000
X-MC-Unique: 9X0Ntu3lPqyJDUuLsEyWOg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 11 Nov
 2023 21:19:40 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 11 Nov 2023 21:19:40 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kent Overstreet' <kent.overstreet@linux.dev>, Colin Ian King
	<colin.i.king@gmail.com>
CC: Brian Foster <bfoster@redhat.com>, "linux-bcachefs@vger.kernel.org"
	<linux-bcachefs@vger.kernel.org>, "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] bcachefs: remove redundant initialization of
 variable level
Thread-Topic: [PATCH][next] bcachefs: remove redundant initialization of
 variable level
Thread-Index: AQHaFOJc+UlSVVrZd0ysZR3wF8M1VrB1n1Cg
Date: Sat, 11 Nov 2023 21:19:40 +0000
Message-ID: <184af6778ab64b3eb6a4a6071974d5e8@AcuMS.aculab.com>
References: <20231111204528.339603-1-colin.i.king@gmail.com>
 <20231111210208.qra7xhf2nd4pqvst@moria.home.lan>
In-Reply-To: <20231111210208.qra7xhf2nd4pqvst@moria.home.lan>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Kent Overstreet <kent.overstreet@linux.dev>
> Sent: 11 November 2023 21:02
> > Variable level is being initialized a value that is never read, the
> > variable is being re-assigned another value several statements later
> > on. The initialization is redundant and can be removed. Cleans up
> > clang scan build warning:
> >
> > fs/bcachefs/btree_iter.c:1217:11: warning: Value stored to 'level'
> > during its initialization is never read [deadcode.DeadStores]
> >
> > Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
>=20
> since we're no longer gnu89, we can simply declare the variable when
> it's first used, like so:

ugg... I think that is still frowned upon.
It makes it very difficult for the average human to find
the variable declaration.

=09David

>=20
> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> index 96bdf0c6051c..104172f6822b 100644
> --- a/fs/bcachefs/btree_iter.c
> +++ b/fs/bcachefs/btree_iter.c
> @@ -1214,8 +1214,6 @@ __bch2_btree_path_set_pos(struct btree_trans *trans=
,
>  =09=09   struct btree_path *path, struct bpos new_pos,
>  =09=09   bool intent, unsigned long ip, int cmp)
>  {
> -=09unsigned level =3D path->level;
> -
>  =09bch2_trans_verify_not_in_restart(trans);
>  =09EBUG_ON(!path->ref);
>=20
> @@ -1231,7 +1229,7 @@ __bch2_btree_path_set_pos(struct btree_trans *trans=
,
>  =09=09goto out;
>  =09}
>=20
> -=09level =3D btree_path_up_until_good_node(trans, path, cmp);
> +=09unsigned level =3D btree_path_up_until_good_node(trans, path, cmp);
>=20
>  =09if (btree_path_node(path, level)) {
>  =09=09struct btree_path_level *l =3D &path->l[level];

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

